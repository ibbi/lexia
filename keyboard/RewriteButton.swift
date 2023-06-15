//
//  RewriteButton.swift
//  keyboard
//
//  Created by ibbi on 6/14/23.
//

import SwiftUI
import KeyboardKit

struct RewriteButton: View {
    @State private var transformedText: String?
    let controller: KeyboardInputViewController

    func rewriteSelectedText() {
        if let selectedText = controller.keyboardTextContext.selectedText {
            API.sendTranscribedText(selectedText) { result in
                switch result {
                case .success(let transformed):
                    DispatchQueue.main.async {
                        transformedText = transformed
                        // Replace selected text with transformedText
                        controller.textDocumentProxy.deleteBackward(times: selectedText.count)
                        controller.textDocumentProxy.insertText(transformed)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    var body: some View {
        Button("Rewrite", action: {
            rewriteSelectedText()
        })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pastelGray)
    }
}

//struct RewriteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        RewriteButton()
//    }
//}
