//
//  InAppUndoButton.swift
//  dyslexia
//
//  Created by ibbi on 7/3/23.
//

import SwiftUI
import KeyboardKit

struct InAppUndoButton: View {
    @Binding var inputText: String
    var prevInputText: String
    
    func hasRecentRewrite() -> Bool {
        if inputText == prevInputText {
            return false
        }
        return true
    }

    func tryUndo() {
        if (!hasRecentRewrite()) {
            return
        }
        inputText = prevInputText
        // TODO: restore cursor position here
    }
    
    var body: some View {
        HStack {
            Button(action: {
                tryUndo()
            }) {
                Text("Undo")
            }
            .buttonStyle(.bordered)
            .tint(Color.pastelRed)
        }
    }
    
}
