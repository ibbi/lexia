//
//  TranscribeButton.swift
//  dyslexia
//
//  Created by ibbi on 5/15/23.
//

import SwiftUI
import KeyboardKit
import URLProxy

struct TranscribeButton: View {
    let controller: KeyboardInputViewController

    var body: some View {
            Button("Boop", action: {
                if controller.hostBundleId != "ibbi.dyslexia" {
                    let urlHandler = URLHandler()
                    urlHandler.openURL("dyslexia://dictation")
                }
                else {
                    // TODO: Handle dictation on this page
                }
                
//                if let t = controller.textDocumentProxy.selectedText {
//                    // TODO: Open the Dictation() deeplink
//                    controller.textDocumentProxy.insertText("Let's GPT " + t)
//                } else {
//                    controller.textDocumentProxy.insertText("Talk to me")
//                }
                
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
