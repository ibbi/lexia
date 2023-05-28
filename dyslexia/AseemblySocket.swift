//
//  AseemblySocket.swift
//  dyslexia
//
//  Created by ibbi on 5/28/23.
//

import Foundation

class AssemblySocket {
    private var urlSession: URLSession!
    private var webSocketTask: URLSessionWebSocketTask!

    init() {
        let urlSession = URLSession(configuration: .default)
        self.urlSession = urlSession

        let url = URL(string: "wss://api.assemblyai.com/v2/realtime/ws")!  // replace with your WebSocket server URL
        self.webSocketTask = urlSession.webSocketTask(with: url)
    }

    func connect() {
        // Start the task.
        webSocketTask.resume()

        // Begin receiving messages.
        receiveMessage()

        // Manually call "on open" behavior.
        onOpen()
    }

    func disconnect() {
        // Cancel the WebSocket task to close the connection.
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }

    func send(text: String) {
        // Wrap the string in a WebSocketMessage and send it.
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask.send(message) { error in
            if let error = error {
                print("Error when sending a message: \(error)")
            }
        }
    }

    private func receiveMessage() {
        webSocketTask.receive { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError(error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.onMessage(text)
                case .data(let data):
                    // Convert Data to String
                    if let text = String(data: data, encoding: .utf8) {
                        self?.onMessage(text)
                    }
                @unknown default:
                    fatalError()
                }

                // Continue listening for messages.
                self?.receiveMessage()
            }
        }
    }

    private func onOpen() {
        print("WebSocket opened")
        // Your equivalent onOpen logic goes here.
        let authHeader = ["Authorization": K.Assembly]
        let sampleRate = 16000
        let wordBoost = ["HackerNews", "Twitter"]
        let payload = [
            "sample_rate": sampleRate,
            "word_boost": wordBoost
        ] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: payload)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            send(text: jsonString)
        }
    }

    private func onMessage(_ text: String) {
        guard let data = text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return
        }
        if let messageType = json["message_type"] as? String {
            switch messageType {
            case "SessionBegins":
                if let sessionId = json["session_id"], let expiresAt = json["expires_at"] {
                    print("Session ID: \(sessionId)")
                    print("Expires at: \(expiresAt)")
                }
            case "PartialTranscript":
                if let transcript = json["text"] as? String {
                    print("Partial transcript received: \(transcript)")
                }
            case "FinalTranscript":
                if let transcript = json["text"] as? String {
                    print("Final transcript received: \(transcript)")
                }
            default:
                break
            }
        }
    }

    private func onError(_ error: Error) {
        print("WebSocket error: \(error)")
        // Your equivalent onError logic goes here.
        if let err = error as? URLError, err.errorCode == 4000 {
            print("Sample rate must be a positive integer")
        }
    }

    func sendAudio(_ audioData: Data) {
        let payload: [String: Any] = [
            "audio_data": audioData.base64EncodedString()
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: payload)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            send(text: jsonString)
        }
    }

    func terminateSession() {
        let payload: [String: Any] = [
            "terminate_session": true
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: payload)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            send(text: jsonString)
        }
        disconnect()
    }
}
