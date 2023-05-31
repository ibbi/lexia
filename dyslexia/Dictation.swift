//
//  Dictation.swift
//  dyslexia
//
//  Created by ibbi on 5/19/23.
//

import SwiftUI
import AVFoundation

struct Dictation: View {
    @State private var isRecording = false
    
    @StateObject private var audioCapture = AudioCapture()
    @StateObject private var webSocket = WebSocketManager()
    
    var body: some View {
        VStack {
            Group {
                Spacer()
                Button("Start socket") {
                    webSocket.startConnection()
                }
                Spacer()
                Button("send hello") {
                    webSocket.sendMessage("")
                }
                Spacer()
                Button("Stop socket"){
                    webSocket.disconnect()
                }
                Spacer()
                if let message = webSocket.latestMessage {
                    Text("Latest message: \(message)")
                }
                Spacer()
            }
            Group {
                Text(isRecording ? "Recording..." : "Not Recording")
                Spacer()
                Button(action: {
                    if isRecording {
                        audioCapture.stop()
                    } else {
                        audioCapture.start()
                    }
                    
                    isRecording.toggle()
                }) {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
            .onAppear {
//                startRecording()
//                webSocket.startConnection()
//                jumpBackToPreviousApp()
            }
            .onDisappear {
//                webSocket.disconnect()
            }
    }
    
}

struct Dictation_Previews: PreviewProvider {
    static var previews: some View {
        Dictation()
    }
}
