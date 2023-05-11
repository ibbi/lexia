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
            Text("Try yelling")
                .font(.title)
            
            Text("Now try to whisper")
                .font(.title)
            
            TextField("Enter text", text: $inputText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isInputFocused)
            
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
