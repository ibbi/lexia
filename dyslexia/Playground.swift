//
//  Playground.swift
//  dyslexia
//
//  Created by ibbi on 5/10/23.
//

import SwiftUI
import KeyboardKit

struct Playground: View {
    @FocusState private var isInputFocused: Bool
    @State private var inputText: String = ""
    @State private var isLexiaActive: Bool = KeyboardEnabledState(bundleId: "ibbi.dyslexia.*").isKeyboardActive
    
    var body: some View {
        VStack {
            // this bool seems flipped in practice?
            if isLexiaActive {
                HStack {
                    Text("Tap and hold the ")
                    Image(systemName: "globe")
                    Text(" below and select Lexia")
                }
                Spacer()                
            }
            Text("Try yelling")
            Text("Now try whisper")
            
            TextEditor( text: $inputText)
                .padding()
                .focused($isInputFocused)
            
            Spacer()
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UITextInputMode.currentInputModeDidChangeNotification, object: nil, queue: .main) { _ in
                isLexiaActive = KeyboardEnabledState(bundleId: "ibbi.dyslexia.*").isKeyboardActive
            }
            isInputFocused = true
        }
    }
}
struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground()
    }
}
