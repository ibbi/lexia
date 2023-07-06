//
//  TranscribeButton.swift
//  dyslexia
//
//  Created by ibbi on 5/15/23.
//

import URLProxy
import SwiftUI
import KeyboardKit

struct TranscribeButton: View {
    let controller: KeyboardInputViewController
    @State var isTranscribing: Bool = false
    let sharedDefaults = UserDefaults(suiteName: "group.lexia")

    
    func tryTranscribe() {
        func sharedDirectoryURL() -> URL {
            let fileManager = FileManager.default
            return fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")!
        }
        
        func getAudioURL() -> URL {
            let sharedDataPath = sharedDirectoryURL()
            return sharedDataPath.appendingPathComponent("recording.m4a")
        }
        
        func transcribeAudio(completion: @escaping (Result<String, BackendAPIError>) -> Void) {
            let audioURL = getAudioURL()
            API.sendAudioForTranscription(audioURL: audioURL, completion: completion)
        }
        
        let audioURL = getAudioURL()
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: audioURL.path) {
            isTranscribing = true
            transcribeAudio { result in
                isTranscribing = false
                switch result {
                case .success(let text):
                    if !text.isEmpty {
                        controller.textDocumentProxy.insertText(text)
                    }
                    do {
                        try fileManager.removeItem(at: audioURL)
                    } catch {
                        print("Error deleting file: \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    var body: some View {
            Button(action: {
                let urlHandler = URLHandler()
                urlHandler.openURL("dyslexia://dictation")
            }) {
                Text(isTranscribing ? "Loading..." :"Speak")
            }
            .buttonStyle(.bordered)
            .tint(Color.pastelBlue)
            .disabled(isTranscribing)
            .padding(.horizontal)
            .onAppear {
                tryTranscribe()
            }
    }
    
}
//struct TranscribeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscribeButton()
//    }
//}
