//
//  InAppRewriteButton.swift
//  dyslexia
//
//  Created by ibbi on 7/1/23.
//

import SwiftUI
import KeyboardKit

struct InAppRewriteButton: View {
    @State private var transformedText: String?
    @Binding var recentTranscription: String
    @State private var selectedText: String?
    @State private var isLoading: Bool = false
    @Binding var inputText: String


    func rewriteText(_ text: String, shouldDelete: Bool) {
        isLoading = true
        API.sendTranscribedText(text) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let transformed):
                    transformedText = transformed
//                    if shouldDelete {
//                        controller.textDocumentProxy.deleteBackward(times: text.count)
//                    }
//                    controller.textDocumentProxy.insertText(transformed)
                    inputText = transformed
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func rewriteSelectedText() {
        if false {
            rewriteText("selectedText", shouldDelete: false)
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
