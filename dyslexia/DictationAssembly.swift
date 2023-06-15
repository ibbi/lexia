//
//  Dictation.swift
//  dyslexia
//
//  Created by ibbi on 5/19/23.
//

import SwiftUI
import AVFoundation

struct DictationAssembly: View {
    @State private var isConnected = false
    @State private var transformedText: String?
    
    @StateObject private var webSocket = AssemblySocketManager()
    @StateObject private var audioRecorder: StreamingAudioRecorder
    init() {
        let webSocket = AssemblySocketManager()
        _webSocket = StateObject(wrappedValue: webSocket)
        _audioRecorder = StateObject(wrappedValue: StreamingAudioRecorder(webSocketManager: webSocket))
    }
    
    func sendTranscribedText() {
        let transcribedText = webSocket.transcriptions.joined(separator: " ") + (webSocket.latestTranscription ?? "")
        API.sendTranscribedText(transcribedText) { result in
            switch result {
            case .success(let transformed):
                DispatchQueue.main.async {
                    transformedText = transformed
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
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
                if let transformed = transformedText {
                    Text(transformed)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            Button(action: {
                sendTranscribedText()
            }) {
                Text("Rewrite")
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
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

struct DictationAssembly_Previews: PreviewProvider {
    static var previews: some View {
        DictationAssembly()
    }
}
