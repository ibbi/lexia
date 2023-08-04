//
//  ConfirmEditButton.swift
//  keyboard
//
//  Created by ibbi on 8/4/23.
//

import SwiftUI
import KeyboardKit
import Combine

struct ConfirmEditButton: View {
    let controller: KeyboardInputViewController
    var prevContext: String?
    var wasSelectedText: Bool
    @Binding var keyboardStatus: KeyboardStatus
    let isGmail: Bool
    @Binding var isInEditMode: Bool
    var editText: String
    var initialText: String
    let resetEditSpace: () -> Void
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
            if let range = fullText.range(of: initialText) {
                let replacedText = fullText.replacingCharacters(in: range, with: editText)
                controller.textDocumentProxy.deleteBackward(times: fullText.count)
                controller.textDocumentProxy.insertText(replacedText)
            } else {
                //TODO: Add some kin of display that says this is happening
                print("oh shiet")
                DispatchQueue.main.async {
                    UIPasteboard.general.string = editText
                }
            }
            fullText = ""
            afterText = ""
            prevText = ""
            keyboardStatus = .available
            resetEditSpace()
            return true
        }
        prevText = (before ?? "") + prevText
        let len = (before?.count ?? 0) * -1
        controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: len)
        return false
    }
    
    func decideSelectionOrEntire() {
        isLoading = true
        withAnimation {
            isInEditMode = false
        }
        
        keyboardStatus = .rewriting
        if (initialText == editText) {
            keyboardStatus = .available
            // do nothing
        }
        //TODO: Select and same context shortcuts don't work because cursor doesn't update in time.
        else if (KeyHelper.getFiveSurroundingChars(controller: controller) == prevContext) {
            if (!wasSelectedText) {
                controller.textDocumentProxy.deleteBackward(times: initialText.count)
            }
            controller.textDocumentProxy.insertText(editText)
            keyboardStatus = .available
            resetEditSpace()
        } else {
            self.moveToEndCancellable = self.moveToEndTimer.sink { _ in
                DispatchQueue.main.async {
                    self.moveCursorToEnd()
                }
            }
        }
    }
    
    var body: some View {
        TopBarButton(buttonType: .confirm, action: {
            decideSelectionOrEntire()
        }, isLoading: $isLoading, isInBadContext: false)
    }
}
