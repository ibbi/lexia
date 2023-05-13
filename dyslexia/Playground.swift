//
//  Playground.swift
//  dyslexia
//
//  Created by ibbi on 5/10/23.
//

import SwiftUI

struct Playground: View {
    @FocusState private var isInputFocused: Bool
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Tap and hold the ")
                Image(systemName: "globe")
                Text(" and ensure Lexia is selected")
            }
            Spacer()
            Text("Try yelling")
            Text("Now try whisper")
            
            TextEditor( text: $inputText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isInputFocused)
                .frame(maxHeight: .infinity)
            
            Spacer()
        }
        .onAppear {
           isInputFocused = true
       }
    }
}
struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground()
    }
}
