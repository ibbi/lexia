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
    
    func tryTranscribe() {
        func sharedDirectoryURL() -> URL {
            let fileManager = FileManager.default
            return fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")!
        }
        
        func getAudioURL() -> URL {
            let sharedDataPath = sharedDirectoryURL()
            return sharedDataPath.appendingPathComponent("recording.m4a")
        }

        func transcribeAudio(completion: @escaping (Result<[String: Any], BackendAPIError>) -> Void) {
            let audioURL = getAudioURL()
            API.sendAudioForTranscription(audioURL: audioURL, completion: completion)
        }

        let audioURL = getAudioURL()
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: audioURL.path) {
            transcribeAudio { result in
                switch result {
                case .success(let json):
                    if let text = json["text"] as? String {
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
        Button("Talk", action: {
            if controller.hostBundleId != "ibbi.dyslexia" {
                let urlHandler = URLHandler()
                urlHandler.openURL("dyslexia://dictation")
            }
            else {
                // TODO: Handle dictation on this page
            }
        })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pastelBlue)
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
