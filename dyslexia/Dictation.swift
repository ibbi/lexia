//
//  Dictation.swift
//  dyslexia
//
//  Created by ibbi on 5/19/23.
//

import SwiftUI
import AVFoundation

struct Dictation: View {

    @State private var isConnected = false
    
    @StateObject private var webSocket = WebSocketManager()
    @StateObject private var audioRecorder: AudioRecorder

    init() {
        let webSocket = WebSocketManager()
        _webSocket = StateObject(wrappedValue: webSocket)
        _audioRecorder = StateObject(wrappedValue: AudioRecorder(webSocketManager: webSocket))
    }

    var body: some View {
        VStack {
            VStack {
                ForEach(webSocket.transcriptions.indices, id: \.self) { index in
                    Text(webSocket.transcriptions[index])
                }
                if let transcription = webSocket.latestTranscription {
                    Text(transcription)
                }
            }
            .padding()
            Button(action: {
                audioRecorder.stopRecording()
                Helper.jumpBackToPreviousApp()
            }) {
                Text("Stop Recording")
                    .font(.title2)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            webSocket.startConnection { success in
                isConnected = success
                if success {
                    audioRecorder.startRecording()
                }
            }
        }
    }
}

struct Dictation_Previews: PreviewProvider {
    static var previews: some View {
        Dictation()
    }
}
