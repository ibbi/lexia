//
//  SpeakPlayground.swift
//  dyslexia
//
//  Created by ibbi on 7/7/23.
//

import KeyboardKit
import SwiftUI

struct SpeakPlayground: View {
    @StateObject private var keyboardState = KeyboardEnabledState(bundleId: "ibbi.dyslexia.*")
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
            if !keyboardState.isKeyboardActive {
                Text("Tap and hold the \(Image(systemName: "globe")) below, then select Lexboard")
                    .font(.title)
            } else {
                VStack(alignment: .leading) {
                    Text("Use \(Image(systemName: "globe")) to dictate, in any language")
                        .font(.title)
                        .padding(.bottom)
                    Text("When was the last time you saw a cow?")
                    Text("How big was it?")
                }
            }
            Divider()
            VStack {
                Spacer()
                TextViewWrapper(text: $inputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange, isFocused: $isFocused)
                    .onAppear {
                        self.isFocused = true
                    }
                    .padding(.horizontal)
                if !isRecording && keyboardState.isKeyboardActive {
                    HStack {
                        InAppTranscribeButton(inputText: $inputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange)
                        Spacer()
                    }
                    .padding(6)
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                }
            }
        }
    }
}


struct SpeakPlayground_Previews: PreviewProvider {
    static var previews: some View {
        SpeakPlayground()
    }
}
