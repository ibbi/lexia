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
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false
    @State private var recentTranscription: String = ""

    
    var body: some View {
        VStack {
            if !isKeyboardActive {
                Text("Tap and hold the \(Image(systemName: "globe")) below, then select Lexboard")
                    .font(.title)
                    .foregroundColor(Color.pastelBlue)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text("Try yelling")
            }
            
            TextEditor( text: $inputText)
                .padding()
                .focused($isInputFocused)
                .toolbar {
                    if !isRecording && isKeyboardActive {
                        
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                                InAppTranscribeButton(recentTranscription: $recentTranscription, inputText: $inputText)
                                Spacer()
                                InAppRewriteButton(recentTranscription: $recentTranscription, inputText: $inputText)
                            }
                            .padding(.vertical)
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
