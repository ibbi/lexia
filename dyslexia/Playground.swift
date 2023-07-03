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
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextViewWrapper

        init(_ parent: TextViewWrapper) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
    }
}

struct Playground: View {
    let isKeyboardActive: Bool
    
    @FocusState private var isInputFocused: Bool
    @State private var inputText: String = "Once a silent keyboard in a tech shop, Lexboard found its voice when a lightning bolt zapped it into the cyberworld. From observer to participant, it evolved, learning to reach billions of iPhone users. It offered innovative suggestions, simplified tasks, and sparked creativity, turning its dormant ideas into dynamic user experiences. \n\nFrom a mere keyboard to a global influencer, Lexboard transformed into an unsung pocket hero."
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false

    
    var body: some View {
        VStack {
            if !isKeyboardActive {
                Text("Tap and hold the \(Image(systemName: "globe")) below, then select Lexboard")
                    .font(.title)
                    .foregroundColor(Color.pastelBlue)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text("Try yelling")
            }
            VStack {
                TextViewWrapper(text: $inputText)
                    .padding()
                    .onAppear {
                        isInputFocused = true
                    }
                if !isRecording && isKeyboardActive {
                    HStack {
                        InAppTranscribeButton(inputText: $inputText)
                        Spacer()
                        InAppRewriteButton(inputText: $inputText)
                    }
                    .padding(.vertical)
                }
            }
            
//            TextEditor( text: $inputText)
//                .padding()
//                .focused($isInputFocused)
//                .toolbar {
//                    if !isRecording && isKeyboardActive {
//
//                        ToolbarItemGroup(placement: .keyboard) {
//                            HStack {
//                                InAppTranscribeButton(inputText: $inputText)
//                                Spacer()
//                                InAppRewriteButton(inputText: $inputText)
//                            }
//                            .padding(.vertical)
//                        }
//                    }
//                }
            
            Spacer()
        }
//        .onAppear {
//            isInputFocused = true
//        }
    }
}
struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground(isKeyboardActive: true)
    }
}
