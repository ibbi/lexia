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
    @State var isLoading: Bool = false
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
        isLoading = false
        // TODO: restore cursor position here
    }
    
    var body: some View {
        if (hasRecentRewrite()) {
            TopBarButton(buttonType: ButtonType.undo, action: {tryUndo()}, isLoading: $isLoading, onlyVisual: false, isInBadContext: false)
        }
    }
    
}
