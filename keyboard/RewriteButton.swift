//
//  RewriteButton.swift
//  keyboard
//
//  Created by ibbi on 6/14/23.
//

import SwiftUI
import KeyboardKit
import Combine

struct RewriteButton: View {
    let controller: KeyboardInputViewController
    @Binding var rewrittenText: String
    @Binding var prewrittenText: String
    @Binding var prevContext: String?
    @State var forceUpdateButtons: Bool
    @Binding var keyboardStatus: KeyboardStatus
    let isGmail: Bool
    @State private var selectedText: String?
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
            afterText = ""
            prevText = ""
            return true
        }
        prevText = (before ?? "") + prevText
        let len = (before?.count ?? 0) * -1
        controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: len)
        return false
    }

    func rewriteText(_ text: String, shouldDelete: Bool) {
        isLoading = true
        prewrittenText = text
        keyboardStatus = .rewriting
        API.sendTranscribedText(text) { result in
            DispatchQueue.main.async {
                isLoading = false
                keyboardStatus = .available
                switch result {
                case .success(var transformed):
                    if shouldDelete {
                        controller.textDocumentProxy.deleteBackward(times: text.count)
                    }
                    controller.textDocumentProxy.insertText(transformed)
                    rewrittenText = transformed
                    prevContext = KeyHelper.getFiveSurroundingChars(controller: controller)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func decideSelectionOrEntire() {
        if let selectedText = controller.keyboardTextContext.selectedText {
            rewriteText(selectedText, shouldDelete: false)
        } else if controller.textDocumentProxy.documentContext != nil {
            keyboardStatus = .reading
            self.moveToEndCancellable = self.moveToEndTimer.sink { _ in
                DispatchQueue.main.async {
                    self.moveCursorToEnd()
                }
            }
        }
    }

    var body: some View {
            TopBarButton(buttonType: ButtonType.enhance, action: {
                decideSelectionOrEntire()
            }, isLoading: $isLoading, onlyVisual: false, isInBadContext: (((controller.keyboardTextContext.selectedText ?? "").isEmpty) && ((controller.textDocumentProxy.documentContext ?? "").isEmpty)))
            .onChange(of: fullText) { newValue in
                if (!newValue.isEmpty) {
                    rewriteText(fullText, shouldDelete: true)
                    fullText = ""
                }
            }
            .id(forceUpdateButtons)
    }
}

//struct RewriteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        RewriteButton()
//    }
//}
