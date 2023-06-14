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
    
    @StateObject private var audioRecorder = AudioRecorder()
    
    func transcribeAudio() {
        audioRecorder.transcribeAudio { result in
            switch result {
            case .success(let json):
                if let text = json["text"] as? String {
                    DispatchQueue.main.async {
                        transcription = text
                        storeTranscriptionAndJumpBack()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func storeTranscriptionAndJumpBack() {
        if let transcription = transcription {
            let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")
            let transcriptionURL = sharedContainerURL?.appendingPathComponent("transcription.txt")
            
            do {
                try transcription.write(to: transcriptionURL!, atomically: true, encoding: .utf8)
                Helper.jumpBackToPreviousApp()
            } catch {
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
            }
            .padding()
            
            Button(action: {
                audioRecorder.stopRecording()
                transcribeAudio()
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
