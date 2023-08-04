//
//  UndoButton.swift
//  keyboard
//
//  Created by ibbi on 7/3/23.
//

import SwiftUI
import KeyboardKit

struct UndoRedoButtons: View {
    @Binding var editText: String
    @Binding var undoRedoStack: [String]
    @Binding var undoRedoIdx: Int
    @State private var isInternalChange = false
    
    var body: some View {
        HStack {
            TopBarButton(buttonType: ButtonType.undo, action: {
                undoRedoIdx = max(0, undoRedoIdx - 1)
            }, isLoading: .constant(false), isInBadContext: undoRedoIdx == 0)
            
            TopBarButton(buttonType: .redo, action: {
                undoRedoIdx = min(undoRedoStack.count - 1, undoRedoIdx + 1)
            }, isLoading: .constant(false), isInBadContext: undoRedoIdx >= undoRedoStack.count - 1)
        }
        .onChange(of: undoRedoIdx) { _ in
            if !isInternalChange {
                isInternalChange = true
                editText = undoRedoStack[undoRedoIdx]
            }
            else {
                isInternalChange = false
            }
        }
        .onChange(of: editText) { _ in
            if !isInternalChange {
                isInternalChange = true
                if undoRedoIdx < undoRedoStack.count - 1 {
                    undoRedoStack.removeSubrange((undoRedoIdx + 1)...)
                }
                undoRedoStack.append(editText)
                undoRedoIdx = undoRedoStack.count - 1
            }
            else {
                isInternalChange = false
            }
        }
    }
}
