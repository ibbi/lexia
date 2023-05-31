//
//  AseemblySocket.swift
//  dyslexia
//
//  Created by ibbi on 5/28/23.
//

import Foundation

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var latestMessage: String?

    func connect() {
        let url = URL(string: "wss://socketsbay.com/wss/v2/1/demo/")!
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func sendMessage(_ message: String) {
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.latestMessage = text
                    }
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    print("Unknown data received.")
                }
            }
            
            // Listening for the next message.
            self?.receiveMessage()
        }
    }
}
