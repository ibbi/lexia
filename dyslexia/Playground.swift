//
//  Playground.swift
//  dyslexia
//
//  Created by ibbi on 5/10/23.
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




struct Playground: View {
    let isKeyboardActive: Bool
    @State private var isFocused: Bool = false // New state variable for focus status
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false
    @State private var prevCursorPosition: Int?
    @State private var prevInputText = ""
    @State private var inputText: String = "Once a silent keyboard in a tech shop, Lexboard found its voice when a lightning bolt zapped it into the cyberworld. From observer to participant, it evolved, learning to reach billions of iPhone users. It offered innovative suggestions, simplified tasks, and sparked creativity, turning its dormant ideas into dynamic user experiences. \n\nFrom a mere keyboard to a global influencer, Lexboard transformed into an unsung pocket hero."
    @State private var selectedText: String = ""
    @State private var selectedTextRange: NSRange = NSRange(location: 0, length: 0)


    
    var body: some View {
        VStack {
            if !isKeyboardActive {
                Text("Tap and hold the \(Image(systemName: "globe")) below, then select Lexboard")
                    .font(.title)
                    .foregroundColor(Color.pastelBlue)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text("Try rewriting the text, or selecting a portion and only rewriting that!")
                Text("You can also use the \(Image("Micon")) to get high quality dictation.")
            }
            VStack {
                TextViewWrapper(text: $inputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange, isFocused: $isFocused)
                    .padding()
                    .onAppear { // Focus the TextViewWrapper when it appears
                        self.isFocused = true
                    }
                if !isRecording && isKeyboardActive {
                    HStack {
                        InAppTranscribeButton(inputText: $inputText)
                        InAppRewriteButton(inputText: $inputText, prevInputText: $prevInputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange)
                        InAppUndoButton(inputText: $inputText, prevInputText: prevInputText)
                    }
                    .padding(.vertical)
                }
            }
            Spacer()
        }
    }
}


struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground(isKeyboardActive: true)
    }
}
