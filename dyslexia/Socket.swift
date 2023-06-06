//
//  AseemblySocket.swift
//  dyslexia
//
//  Created by ibbi on 5/28/23.
//

import Foundation
import AVFoundation

struct AudioData: Codable {
    let audio_data: String
}

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var latestMessage: String?
    var isConnected: Bool {
        return webSocketTask?.state == .running
    }
    
    
    func startConnection() {
        getToken { [weak self] token in
            self?.connect(with: token)
        }
    }

    // Fetch the token from the server
    private func getToken(completion: @escaping (String) -> Void) {
        let url = URL(string: "https://basic-bundle-long-queen-51be.ibm456.workers.dev/")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch token: \(error)")
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let token = json["token"] as? String else {
                print("Failed to parse token from response.")
                return
            }
            
            completion(token)
        }
        
        task.resume()
    }
    

    private func connect(with token: String) {
        let url = URL(string: "wss://api.assemblyai.com/v2/realtime/ws?sample_rate=48000&token=\(token)")!
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    func disconnect() {
        // Send terminate_session message
        let terminateMessage: [String: Any] = ["terminate_session": true]
        if let jsonData = try? JSONSerialization.data(withJSONObject: terminateMessage, options: []) {
            webSocketTask?.send(.data(jsonData)) { [weak self] error in
                if let error = error {
                    print("WebSocket couldn’t send termination message because: \(error)")
                } else {
                    // If termination message sent successfully, then close the connection
                    self?.webSocketTask?.cancel(with: .normalClosure, reason: nil)
                }
            }
        } else {
            print("Failed to encode termination message as JSON.")
        }
    }
    
    func sendData(_ data: Data) {
        webSocketTask?.send(.data(data)) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }
    
    func sendMessage(_ message: String) {
        guard let webSocketTask = webSocketTask, webSocketTask.state == .running else {
            print("WebSocket isn't connected.")
            return
        }

        let audioData = AudioData(audio_data: message)
        let jsonEncoder = JSONEncoder()

        do {
            let jsonData = try jsonEncoder.encode(audioData)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON object: \(jsonString)")
                webSocketTask.send(.string(jsonString)) { error in
                    if let error = error {
                        print("WebSocket couldn’t send message because: \(error)")
                    }
                }
            }
        } catch {
            print("Failed to encode message as JSON: \(error.localizedDescription)")
        }
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
                if (self?.webSocketTask?.state != .running) {
                    print("WebSocket connection isn't running.")
                }
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.latestMessage = text
                    }
                    print("Received message: \(text)") // Print the entire received message
                    
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    print("Unknown data received.")
                }
            }

            if (self?.webSocketTask?.state == .running) {
                // Listening for the next message.
                self?.receiveMessage()
            } else {
                print("Stop receiving because WebSocket isn't running.")
            }
        }
    }
}
