//
//  Paste.swift
//  keyboard
//
//  Created by ibbi on 6/14/23.

import SwiftUI
import KeyboardKit

struct Paste: View {
    let controller: KeyboardInputViewController

    var body: some View {
        Button("Paste", action: {
            let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")
            let transcriptionURL = sharedContainerURL?.appendingPathComponent("transcription.txt")
            
            do {
                let storedTranscription = try String(contentsOf: transcriptionURL!, encoding: .utf8)
                controller.textDocumentProxy.insertText(storedTranscription)
            } catch {
                print("Error: \(error)")
                controller.textDocumentProxy.insertText("yo sup")
            }
        })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pastelGray)
    }
}

//struct TranscribeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscribeButton()
//    }
//}
