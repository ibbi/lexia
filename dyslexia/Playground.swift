//
//  Playground.swift
//  dyslexia
//
//  Created by ibbi on 5/10/23.
//

import KeyboardKit
import SwiftUI

struct Playground: View {
    let isKeyboardActive: Bool
    @State private var isFocused: Bool = false
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false
    @State private var prevCursorPosition: Int?
    @State private var prevInputText = ""
    @State private var inputText: String = ""
    @State private var selectedText: String = ""
    // Hardcoded length of inputText
    @State private var selectedTextRange: NSRange = NSRange(location: 0, length: 0)
    

    var body: some View {
        VStack {
            if !isKeyboardActive {
                Text("Tap and hold the \(Image(systemName: "globe")) below, then select Wordflow")
                    .font(.title)
                Divider()
            }
            VStack {
                TextViewWrapper(text: $inputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange, isFocused: $isFocused)
                    .onAppear { // Focus the TextViewWrapper when it appears
                        self.isFocused = true
                    }
                    .padding(.horizontal)
                    .padding(.top)
                if !isRecording && isKeyboardActive {
                    HStack {
                        InAppTranscribeButton(inputText: $inputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange)
                        InAppVoiceRewriteButton(inputText: $inputText, prevInputText: $prevInputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange)
                        InAppRewriteButton(inputText: $inputText, prevInputText: $prevInputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange)
                        Spacer()
                        InAppUndoButton(inputText: $inputText, prevInputText: prevInputText)
                    }
                    .frame(minHeight: 42)
                    .padding(6)
                    .background(Color.standardKeyboardBackground)
                }
            }
        }
    }
}


struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground(isKeyboardActive: true)
    }
}
