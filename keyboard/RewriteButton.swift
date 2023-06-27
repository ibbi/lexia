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
    @Binding var recentTranscription: String
    @State private var selectedText: String?
    @State private var isLoading: Bool = false



    func rewriteText(_ text: String, shouldDelete: Bool) {
        isLoading = true
        API.sendTranscribedText(text) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let transformed):
                    transformedText = transformed
                    if shouldDelete {
                        controller.textDocumentProxy.deleteBackward(times: text.count)
                    }
                    controller.textDocumentProxy.insertText(transformed)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func rewriteSelectedText() {
        if let selectedText = controller.keyboardTextContext.selectedText {
            rewriteText(selectedText, shouldDelete: false)
        } else if !recentTranscription.isEmpty {
            rewriteText(recentTranscription, shouldDelete: true)
            recentTranscription = ""
        }
    }

    var body: some View {
        Button(action: {
            rewriteSelectedText()
        }) {
            Text(isLoading ? "Loading..." : "Rewrite")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pastelGray)
        }
        .disabled(isLoading)
    }
}

//struct RewriteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        RewriteButton()
//    }
//}
