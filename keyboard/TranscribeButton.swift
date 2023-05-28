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
//                if let t = controller.textDocumentProxy.selectedText {
//                    // TODO: Open the Dictation() deeplink
//                    controller.textDocumentProxy.insertText("Let's GPT " + t)
//                } else {
//                    controller.textDocumentProxy.insertText("Talk to me")
//                }
                let urlHandler = URLHandler()
                // TODO: If already in container app - just run ditation function.
                urlHandler.openURL("dyslexia://dictation")
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
