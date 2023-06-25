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
    

    func pasteTranscription() {
        let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")
        let transcriptionURL = sharedContainerURL?.appendingPathComponent("transcription.txt")
        
        do {
            let storedTranscription = try String(contentsOf: transcriptionURL!, encoding: .utf8)
            
            if !storedTranscription.isEmpty {
                let rangeToSelect = NSRange(location: 0, length: storedTranscription.count)
                controller.textDocumentProxy.setMarkedText("\(storedTranscription)", selectedRange: rangeToSelect)
                
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
