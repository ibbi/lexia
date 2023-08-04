//
//  EditModeButton.swift
//  keyboard
//
//  Created by ibbi on 8/3/23.
//


import SwiftUI
import KeyboardKit
import Combine

struct EditModeButton: View {
    let controller: KeyboardInputViewController
    @Binding var prevContext: String?
    @Binding var wasSelectedText: Bool
    @Binding var keyboardStatus: KeyboardStatus
    let isGmail: Bool
    @Binding var isInEditMode: Bool
    @Binding var editText: String
    @Binding var initialText: String
    @Binding var undoRedoStack: [String]
    @State private var isLoading: Bool = false
    @State private var prevText = ""
    @State private var afterText = ""
    @State private var fullText = ""
    @State private var afterTries = 0
    
    
    let beforeTextTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    let moveToEndTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State private var beforeCancellable: AnyCancellable?
    @State private var moveToEndCancellable: AnyCancellable?
    
    
    func moveCursorToEnd () -> Bool {
        let after = controller.textDocumentProxy.documentContextAfterInput
        
        if (isGmail && KeyHelper.containsGmailReplyPattern(str: after ?? "")) {
            moveToEndCancellable?.cancel()
            afterText = String(afterText.dropLast(afterTries))
            afterTries = 0
            // for some reason character before reply line is special
            controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
            self.beforeCancellable = self.beforeTextTimer.sink { _ in
                DispatchQueue.main.async {
                    self.getTextContextBefore()
                }
            }
            return true
        }
        if ((after == nil) || (after!.isEmpty)){
            // silly hack because sometimes newlines break this jank thing i wrote lel. It breaks if there are more than 10 unexpected newlines in a row.
            if (afterTries < 10) {
                controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
                afterText += "\n"
                afterTries += 1
            } else {
                moveToEndCancellable?.cancel()
                afterText = String(afterText.dropLast(afterTries))
                afterTries = 0
                self.beforeCancellable = self.beforeTextTimer.sink { _ in
                    DispatchQueue.main.async {
                        self.getTextContextBefore()
                    }
                }
                return true
            }
        }
        
        if (afterTries > 0 && afterText != afterText + (after ?? "")) {
            afterTries = 0
        }
        afterText = afterText + (after ?? "")
        let len = (after?.count ?? 0)
        controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: len)
        return false
    }
    
    
    func getTextContextBefore() -> Bool {
        let before = controller.textDocumentProxy.documentContextBeforeInput
        if ((before == nil) || (before!.isEmpty)){
            controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: prevText.count)
            beforeCancellable?.cancel()
            fullText = prevText
            moveTextAndSetEditMode(fullText)
            fullText = ""
            afterText = ""
            prevText = ""
            return true
        }
        prevText = (before ?? "") + prevText
        let len = (before?.count ?? 0) * -1
        controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: len)
        return false
    }
    
    func moveTextAndSetEditMode(_ text: String) {
        prevContext = KeyHelper.getFiveSurroundingChars(controller: controller)
        keyboardStatus = .available
        editText = text
        initialText = text
        undoRedoStack.append(text)
        isLoading = false
        withAnimation {
            isInEditMode = true
        }
    }
    
    func decideSelectionOrEntire() {
        isLoading = true
        let selectedText = controller.keyboardTextContext.selectedText
        if !(selectedText?.isEmpty ?? true) {
            wasSelectedText = true
            moveTextAndSetEditMode(selectedText!)
        }
        else if controller.textDocumentProxy.documentContext != nil {
            keyboardStatus = .reading
            self.moveToEndCancellable = self.moveToEndTimer.sink { _ in
                DispatchQueue.main.async {
                    self.moveCursorToEnd()
                }
            }
        }
    }
    
    func isDisabled() -> Bool {
        return (((controller.keyboardTextContext.selectedText ?? "").isEmpty) && ((controller.textDocumentProxy.documentContext ?? "").isEmpty))
    }
    
    var body: some View {
        TopBarButton(buttonType: .editView, action: {
            decideSelectionOrEntire()
        }, isLoading: $isLoading, isInBadContext: isDisabled())
    }
}
