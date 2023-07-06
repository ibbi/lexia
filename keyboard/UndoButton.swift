//
//  UndoButton.swift
//  keyboard
//
//  Created by ibbi on 7/3/23.
//

import SwiftUI
import KeyboardKit

struct UndoButton: View {
    let controller: KeyboardInputViewController
    @Binding var rewrittenText: String
    @Binding var prewrittenText: String
    @Binding var prevContext: String?
    
    func hasRecentRewrite() -> Bool {
        if rewrittenText.isEmpty || prewrittenText.isEmpty {
            return false
        }
        if (KeyHelper.getFiveSurroundingChars(controller: controller) != prevContext) {
            return false
        }
        return true
    }

    func tryUndo() {
        if (!hasRecentRewrite()) {
            return
        }
        controller.textDocumentProxy.deleteBackward(times: rewrittenText.count)
        controller.textDocumentProxy.insertText(prewrittenText)
        prewrittenText = ""
        rewrittenText = ""
        
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
            .padding(.horizontal)
        }
    }
    
}
