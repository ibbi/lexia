//
//  DictationWhisper.swift
//  dyslexia
//
//  Created by ibbi on 6/13/23.
//

import SwiftUI
import AVFoundation

struct DictationWhisper: View {
    @StateObject private var audioRecorder = AudioRecorder()
    
    func transcribeAudio() {
        audioRecorder.transcribeAudio { result in
            switch result {
            case .success(let json):
                print(json)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Button(action: {
                audioRecorder.stopRecording()
            }) {
                Text("Stop Recording")
                    .font(.title2)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                transcribeAudio()
            }) {
                Text("Transcribe")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
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
