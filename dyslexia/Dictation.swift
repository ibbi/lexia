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
    
    @StateObject private var webSocket = WebSocketManager()
    @StateObject private var audioRecorder: AudioRecorder

    init() {
        let webSocket = WebSocketManager()
        _webSocket = StateObject(wrappedValue: webSocket)
        _audioRecorder = StateObject(wrappedValue: AudioRecorder(webSocketManager: webSocket))
    }

    var body: some View {
        VStack {
            Group {
                Spacer()
                Button("Start socket") {
                    webSocket.startConnection()
                }
                Spacer()
                Button("Stop socket"){
                    webSocket.disconnect()
                }
                Spacer()
                if let message = webSocket.latestMessage {
                    Text("Latest message: \(message)")
                    let thing = print(message)
                }
                Spacer()
            }
            Group {
                Text(isRecording ? "Recording..." : "Not Recording")
                Spacer()
                Button(action: {
                    if isRecording {
                        audioRecorder.stopRecording()
                    } else {
                        audioRecorder.startRecording()
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
    }
}

struct Dictation_Previews: PreviewProvider {
    static var previews: some View {
        Dictation()
    }
}
