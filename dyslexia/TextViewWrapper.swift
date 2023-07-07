//
//  TextViewWrapper.swift
//  dyslexia
//
//  Created by ibbi on 7/7/23.
//

import SwiftUI

struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var selectedText: String
    @Binding var selectedTextRange: NSRange
    @Binding var isFocused: Bool // New binding variable for focus status
    var isEditable: Bool = true

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = self.isEditable
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        let start = uiView.position(from: uiView.beginningOfDocument, offset: selectedTextRange.location) ?? uiView.beginningOfDocument
        let end = uiView.position(from: start, offset: selectedTextRange.length) ?? start
        uiView.selectedTextRange = uiView.textRange(from: start, to: end)

        if self.isFocused {
            uiView.becomeFirstResponder() // Focus the TextView when isFocused is true
        } else {
            uiView.resignFirstResponder() // Remove the focus when isFocused is false
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper

        init(_ parent: TextViewWrapper) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            if let range = textView.selectedTextRange {
                let start = textView.offset(from: textView.beginningOfDocument, to: range.start)
                let end = textView.offset(from: textView.beginningOfDocument, to: range.end)
                DispatchQueue.main.async {
                    self.parent.selectedTextRange = NSRange(location: start, length: end - start)
                    self.parent.selectedText = textView.text(in: range) ?? ""
                }
            }
        }
    }
}
