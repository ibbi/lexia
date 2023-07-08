//
//  EnhancePlayground.swift
//  dyslexia
//
//  Created by ibbi on 7/7/23.
//

import SwiftUI
import KeyboardKit

struct EnhancePlayground: View {
    let isKeyboardActive: Bool
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
            if !isKeyboardActive {
                Text("Tap and hold the \(Image(systemName: "globe")) below, then select Lexboard")
                    .font(.title)
            } else {
                VStack(alignment: .leading) {
                    Text("Use \(Image(systemName: "wand.and.stars")) to apply your saved request to text")
                        .font(.title)
                        .padding(.bottom)
                    
                    Text("Customize your request:")
                    HStack {
                        TextField("Request", text: $promptText)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.primary)
                            )
                            .padding(0)
                                                
                        Button("Update", action: {
                            UserDefaults(suiteName: "group.lexia")?.set(promptText, forKey: "quick_prompt")
                            userDefPrompt = promptText
                        })
                        .buttonStyle(.borderedProminent)
                        .disabled(userDefPrompt == promptText || promptText.isEmpty)
                    }
                }
                .padding()
            }
            Divider()
            VStack {
                TextViewWrapper(text: $inputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange, isFocused: $isFocused)
                    .onAppear { // Focus the TextViewWrapper when it appears
                        self.isFocused = true
                    }
                    .padding(.horizontal)
                if !isRecording && isKeyboardActive {
                    HStack {
                        InAppRewriteButton(inputText: $inputText, prevInputText: $prevInputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange)
                        Spacer()
                        InAppUndoButton(inputText: $inputText, prevInputText: prevInputText)
                    }
                    .frame(minHeight: 42)
                    .padding(6)
                    .background(Color(UIColor.tertiarySystemGroupedBackground))
                }
            }
        }
    }
}

struct EnhancePlayground_Previews: PreviewProvider {
    static var previews: some View {
        EnhancePlayground(isKeyboardActive: true)
    }
}
