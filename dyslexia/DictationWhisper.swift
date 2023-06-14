//
//  DictationWhisper.swift
//  dyslexia
//
//  Created by ibbi on 6/13/23.
//

import SwiftUI
import AVFoundation

struct DictationWhisper: View {
    @State private var transcription: String?
    @State private var transformedText: String?
    
    @StateObject private var audioRecorder = AudioRecorder()
    
    func transcribeAndRewriteAudio() {
        audioRecorder.transcribeAudio { result in
            switch result {
            case .success(let json):
                if let text = json["text"] as? String {
                    DispatchQueue.main.async {
                        transcription = text
                    }
                    API.sendTranscribedText(text) { result in
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
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                if let transcription = transcription {
                    Text(transcription)
                }
                if let transformed = transformedText {
                    Text(transformed)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            Button(action: {
                audioRecorder.stopRecording()
                transcribeAndRewriteAudio()
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
            audioRecorder.startRecording()
        }
    }
}

struct DictationWhisper_Previews: PreviewProvider {
    static var previews: some View {
        DictationWhisper()
    }
}
