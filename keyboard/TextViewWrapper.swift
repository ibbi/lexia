//
//  TextViewWrapper.swift
//  keyboard
//
//  Created by ibbi on 8/3/23.
//

import SwiftUI
import KeyboardKit

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
        textView.backgroundColor = .secondarySystemBackground
        textView.textColor = .secondaryLabel
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.shadowColor = UIColor.gray.cgColor;
        textView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        textView.layer.shadowOpacity = 0.4
        textView.layer.shadowRadius = 1
//        textView.layer.masksToBounds = false
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
