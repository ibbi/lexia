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
    @State private var transformedText: String?
    let controller: KeyboardInputViewController

    func pasteTranscription() {
        let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")
        let transcriptionURL = sharedContainerURL?.appendingPathComponent("transcription.txt")
        
        do {
            let storedTranscription = try String(contentsOf: transcriptionURL!, encoding: .utf8)
            
            if !storedTranscription.isEmpty {
//                controller.textDocumentProxy.insertText(storedTranscription)
                let rangeToSelect = NSRange(location: 0, length: storedTranscription.count)
                controller.textDocumentProxy.setMarkedText("\(storedTranscription)", selectedRange: rangeToSelect)
                
                // Send transcribed text to API only if storedTranscription is not empty
                if !storedTranscription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    API.sendTranscribedText(storedTranscription) { result in
                        switch result {
                        case .success(let transformed):
                            DispatchQueue.main.async {
                                transformedText = transformed
                                // Insert transformedText after receiving a response
                                let rangeToSelect = NSRange(location: 0, length: transformed.count)
                                controller.textDocumentProxy.setMarkedText("\(transformed)", selectedRange: rangeToSelect)
                            }
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
                
                // Clear the shared container's text
                try "".write(to: transcriptionURL!, atomically: true, encoding: .utf8)
            }
        } catch {
            print("Error: \(error)")
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
                pasteTranscription()
            }
    }
}

//struct TranscribeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscribeButton()
//    }
//}
