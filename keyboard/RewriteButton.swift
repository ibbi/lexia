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
    @State private var isButtonDisabled: Bool = true

    func rewriteText(_ text: String, shouldDelete: Bool) {
        API.sendTranscribedText(text) { result in
            switch result {
            case .success(let transformed):
                DispatchQueue.main.async {
                    transformedText = transformed
                    // Replace recentTranscription with transformedText
                    if shouldDelete {
                        controller.textDocumentProxy.deleteBackward(times: text.count)
                    }
                    controller.textDocumentProxy.insertText(transformed)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
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
            Text("Rewrite")
                .frame(maxWidth: .infinity)
                .padding()
                .background(isButtonDisabled ? Color.pastelGray.opacity(0.5) : Color.pastelGray)
        }
        .disabled(isButtonDisabled)
        .onChange(of: controller.keyboardTextContext.selectedText) { newValue in
            controller.textDocumentProxy.insertText("transformed")
            selectedText = newValue
            isButtonDisabled = selectedText == nil && recentTranscription.isEmpty
        }
        .onChange(of: recentTranscription) { _ in
            isButtonDisabled = selectedText == nil && recentTranscription.isEmpty
        }
    }
}

//struct RewriteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        RewriteButton()
//    }
//}
