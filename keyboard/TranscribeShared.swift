//
//  TranscribeButton.swift
//  dyslexia
//
//  Created by ibbi on 5/15/23.
//

import URLProxy
import SwiftUI
import KeyboardKit

struct TranscribeShared: View {
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
        transcribeAudio { result in
            switch result {
            case .success(let json):
                if let text = json["text"] as? String {
                    controller.textDocumentProxy.insertText(text)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    var body: some View {
        Button("Wrtie", action: {
            tryTranscribe()
            
        })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pastelBlue)
    }
}

//struct TranscribeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscribeButton()
//    }
//}
