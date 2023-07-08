//
//  SpeakPlayground.swift
//  dyslexia
//
//  Created by ibbi on 7/7/23.
//

import KeyboardKit
import SwiftUI

struct SpeakPlayground: View {
    let isKeyboardActive: Bool
    @State private var isFocused: Bool = false
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false
    @State private var prevCursorPosition: Int?
    @State private var prevInputText = ""
    @State private var inputText: String = ""
    @State private var selectedText: String = ""
    // Hardcoded length of inputText
    @State private var selectedTextRange: NSRange = NSRange(location: 0, length: 0)
    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        VStack {
            if !isKeyboardActive {
                Text("Tap and hold the \(Image(systemName: "globe")) below, then select Wordflow")
                    .font(.title)
            } else {
                VStack(alignment: .leading) {
                    Text("Tap \(Image(systemName: "mic")), and then speak")
                        .font(.title)
                        .padding(.bottom)
                    Text("Tell me about the last time you saw a cow. How big was it? Did it have horns?")
                }
                .padding()
            }
            Divider()
            VStack {
                Spacer()
                TextViewWrapper(text: $inputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange, isFocused: $isFocused)
                    .onAppear {
                        self.isFocused = true
                    }
                    .padding(.horizontal)
                if !isRecording && isKeyboardActive {
                    HStack {
                        InAppTranscribeButton(inputText: $inputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange)
                        Spacer()
                    }
                    .frame(minHeight: 42)
                    .padding(6)
                    .background(Color.standardKeyboardBackground)
                }
            }
        }
    }
}


struct SpeakPlayground_Previews: PreviewProvider {
    static var previews: some View {
        SpeakPlayground(isKeyboardActive: true)
    }
}
