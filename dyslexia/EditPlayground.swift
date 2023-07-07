//
//  EditPlayground.swift
//  dyslexia
//
//  Created by ibbi on 7/7/23.
//

import SwiftUI
import KeyboardKit

struct EditPlayground: View {
    let isKeyboardActive: Bool
    @State private var isFocused: Bool = false
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false
    @State private var prevCursorPosition: Int?
    @State private var prevInputText = ""
    @State private var inputText: String = "Once a silent keyboard in a tech shop, Lexboard found its voice when a lightning bolt zapped it into the cyberworld. From observer to participant, it evolved, learning to reach billions of iPhone users. It offered innovative suggestions, simplified tasks, and sparked creativity, turning its dormant ideas into dynamic user experiences. \n\nFrom a mere keyboard to a global influencer, Lexboard transformed into an unsung pocket hero."
    @State private var selectedText: String = ""
    // Hardcoded length of inputText
    @State private var selectedTextRange: NSRange = NSRange(location: 432, length: 0)
    

    var body: some View {
        VStack {
            if !isKeyboardActive {
                Text("Tap and hold the \(Image(systemName: "globe")) below, then select Lexboard")
                    .font(.title)
            } else {
                VStack(alignment: .leading) {
                    Text("Use \(Image(systemName: "globe")) to tell me how to change the text (or just a slected portion)")
                        .font(.title)
                        .padding(.bottom)
                    
                    Text("Here are some ideas:")
                    Text("- \"make this story shorter\"")
                    Text("- \"turn this into a poem\"")
                    Text("- \"replace all instances of Lexboard with Jeremy\"")
                }
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
                        InAppVoiceRewriteButton(inputText: $inputText, prevInputText: $prevInputText, selectedText: $selectedText, selectedTextRange: $selectedTextRange)
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

struct EditPlayground_Previews: PreviewProvider {
    static var previews: some View {
        EditPlayground(isKeyboardActive: true)
    }
}
