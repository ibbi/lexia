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
    @State private var isLoading: Bool = false
    @Binding var inputText: String
    @Binding var prevInputText: String
    @Binding var selectedText: String
    @Binding var selectedTextRange: NSRange

    func rewriteText(_ text: String) {
        isLoading = true
        API.sendTranscribedText(text) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let transformed):
                    if !selectedText.isEmpty {
                        prevInputText = inputText
                        let nsString = inputText as NSString
                        inputText = nsString.replacingCharacters(in: selectedTextRange, with: transformed)
                        selectedText = ""
                        selectedTextRange = NSRange(location: selectedTextRange.location + transformed.count, length: 0)
                    } else {
                        prevInputText = inputText
                        inputText = transformed
                        selectedText = ""
                        selectedTextRange = NSRange(location: inputText.count, length: 0)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func tryRewriteText() {
        if !selectedText.isEmpty {
            rewriteText(selectedText)
        } else if !inputText.isEmpty {
            rewriteText(inputText)
        }
    }

    var body: some View {
        Button(action: {
            tryRewriteText()
        }) {
            Text(isLoading ? "Loading..." : "Rewrite")
        }
        .disabled(isLoading)
        .buttonStyle(.bordered)
        .tint(Color.pastelYellow)
    }
}

//struct RewriteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        RewriteButton()
//    }
//}
