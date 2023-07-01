//
//  Playground.swift
//  dyslexia
//
//  Created by ibbi on 5/10/23.
//

import SwiftUI
import KeyboardKit

struct Playground: View {
    let isKeyboardActive: Bool
    
    @FocusState private var isInputFocused: Bool
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            if !isKeyboardActive {
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
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("Click me!") {
                            inputText += "Clack"
                        }
                    }
                }
            
            Spacer()
        }
        .onAppear {
            isInputFocused = true
        }
    }
}
struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground(isKeyboardActive: true)
    }
}
