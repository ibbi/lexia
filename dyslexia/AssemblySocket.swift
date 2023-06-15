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


class AssemblySocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var latestMessage: String?
    @Published var latestTranscription: String?
    @Published var transcriptions: [String] = []
    
    var isConnected: Bool {
        return webSocketTask?.state == .running
    }
    
    func startConnection(completion: @escaping (Bool) -> Void) {
        API.getAssemblyToken { [weak self] result in
            switch result {
            case .success(let token):
                self?.connect(with: token, completion: completion)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    private func connect(with token: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "wss://api.assemblyai.com/v2/realtime/ws?sample_rate=48000&token=\(token)")!
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
        completion(true)
    }
    
    func disconnect() {
        let terminateMessage: [String: Any] = ["terminate_session": true]
        if let jsonData = try? JSONSerialization.data(withJSONObject: terminateMessage, options: []) {
            webSocketTask?.send(.data(jsonData)) { [weak self] error in
                if let error = error {
                    print("WebSocket couldn’t send termination message because: \(error)")
                } else {
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
                    if let jsonData = text.data(using: .utf8),
                       let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        self?.handleTranscription(jsonObject)
                    }
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    print("Unknown data received.")
                }
            }
            
            if (self?.webSocketTask?.state == .running) {
                self?.receiveMessage()
            } else {
                print("Stop receiving because WebSocket isn't running.")
            }
        }
    }
    
    private func handleTranscription(_ jsonObject: [String: Any]) {
        if let messageType = jsonObject["message_type"] as? String,
           let transcription = jsonObject["text"] as? String {
            DispatchQueue.main.async {
                if messageType == "FinalTranscript" {
                    self.transcriptions.append(transcription)
                } else {
                    self.latestTranscription = transcription
                }
            }
        }
    }
}
