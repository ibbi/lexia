//
//  EnhancePlayground.swift
//  dyslexia
//
//  Created by ibbi on 7/7/23.
//

import SwiftUI
import KeyboardKit

struct EnhancePlayground: View {
    @StateObject private var keyboardState = KeyboardEnabledState(bundleId: "ibbi.dyslexia.*")
    @State private var isFocused: Bool = false
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false
    @State private var prevCursorPosition: Int?
    @State private var prevInputText = ""
    @State private var userDefPrompt = UserDefaults(suiteName: "group.lexia")?.string(forKey: "quick_prompt") ?? "Please rewrite this"
    @State private var promptText = UserDefaults(suiteName: "group.lexia")?.string(forKey: "quick_prompt") ?? "Please rewrite this" 
    @State private var inputText: String = "Yo Jeremy - u kinda cut me off a bit in meetings - hard to finish thoughts. Mb we chill a lil on that?"
    @State private var selectedText: String = ""
    // Hardcoded length of inputText
    @State private var selectedTextRange: NSRange = NSRange(location: 102, length: 0)


    var body: some View {
        VStack {
            if !keyboardState.isKeyboardActive {
                Text("Tap and hold the \(Image(systemName: "globe")) below, then select Lexboard")
                    .font(.title)
            } else {
                VStack(alignment: .leading) {
                    Text("Use \(Image(systemName: "globe")) to apply your saved request to text")
                        .font(.title)
                        .padding(.bottom)
                    
                    Text("Request ")
                    HStack {
                        TextField("Request", text: $promptText, prompt: Text("Required"))
                            .textFieldStyle(.roundedBorder)
                        Button("Update", action: {
                            UserDefaults(suiteName: "group.lexia")?.set(promptText, forKey: "quick_prompt")
                            userDefPrompt = promptText
                        })
                        .buttonStyle(.borderedProminent)
                        .disabled(userDefPrompt == promptText)
                    }
                }
            }
            Divider()
            VStack {
                TextViewWrapper(text: $inputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange, isFocused: $isFocused)
                    .onAppear { // Focus the TextViewWrapper when it appears
                        self.isFocused = true
                    }
                    .padding(.horizontal)
                if !isRecording && keyboardState.isKeyboardActive {
                    HStack {
                        InAppRewriteButton(inputText: $inputText, prevInputText: $prevInputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange)
                        Spacer()
                        InAppUndoButton(inputText: $inputText, prevInputText: prevInputText)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

struct EnhancePlayground_Previews: PreviewProvider {
    static var previews: some View {
        EnhancePlayground()
    }
}
