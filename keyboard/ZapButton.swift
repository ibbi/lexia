//
//  ZapButton.swift
//  keyboard
//
//  Created by ibbi on 6/14/23.
//

import SwiftUI
import KeyboardKit
import Combine

struct ZapButton: View {
    let controller: KeyboardInputViewController
    @Binding var prevContext: String?
    @State var forceUpdateButtons: Bool
    @Binding var keyboardStatus: KeyboardStatus
    let isGmail: Bool
    let isInEditMode: Bool
    @Binding var editText: String
    @AppStorage("zap_mode_id", store: UserDefaults(suiteName: "group.lexia")) var zapModeId: String = ZapOptions.casual.id
    let sharedDefaults = UserDefaults(suiteName: "group.lexia")
    @State private var selectedText: String?
    @State private var isLoading: Bool = false
    @State private var prevText = ""
    @State private var afterText = ""
    @State private var fullText = ""
    @State private var afterTries = 0
    @State private var isMenuOpen: Bool = false
    
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
    
    func zapText(_ text: String, shouldDelete: Bool) {
        isLoading = true
        keyboardStatus = .rewriting
        API.sendTextForZap(text) { result in
            DispatchQueue.main.async {
                isLoading = false
                keyboardStatus = .available
                switch result {
                case .success(var transformed):
                    if shouldDelete {
                        controller.textDocumentProxy.deleteBackward(times: text.count)
                    }
                    controller.textDocumentProxy.insertText(transformed)
                    prevContext = KeyHelper.getFiveSurroundingChars(controller: controller)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func decideSelectionOrEntire() {
        let selectedText = controller.keyboardTextContext.selectedText
        if !(selectedText?.isEmpty ?? true) {
            zapText(selectedText!, shouldDelete: false)
        }
        else if isInEditMode && !editText.isEmpty {
            zapText(editText, shouldDelete: true)
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
        Button(action: {}) {
            HStack {
                Button( action: {}) {
                    Menu {
                        ForEach(ZapOptions.allCases, id: \.self) { option in
                            Button(action: {
                                sharedDefaults?.set(option.id, forKey: "zap_mode_id")
                            }) {
                                Text(option.icon + " " + option.description)
                            }
                        }
                    }
                label: {
                    Image(systemName: "ellipsis")
                        .imageScale(.large)
                        .frame(width: 10, height: 25, alignment: .center)
                        .rotationEffect(.degrees(90))
                }
                .onDisappear {
                    isMenuOpen = false
                }
                }
                Divider()
                Button( action: {
                    isLoading = true
                    decideSelectionOrEntire()
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 25, height: 25, alignment: .center)
                        
                    } else {
                        ZStack {
                            Text(ZapOptions.getZapMode(from: zapModeId)?.icon ?? ZapOptions.casual.icon)
                                .grayscale(isDisabled() ? 1 : 0)
                            Image(systemName: "line.diagonal")
                                .imageScale(.large)
                                .frame(width: 25, height: 25, alignment: .center)
                                .rotationEffect(.degrees(90))
                                .opacity(isDisabled() ? 1 : 0)
                        }
                    }
                }
                .disabled(isLoading || isDisabled())
            }
        }
        .id(forceUpdateButtons)
        .onChange(of: fullText) { newValue in
            if (!newValue.isEmpty) {
                zapText(fullText, shouldDelete: true)
                fullText = ""
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.standardButtonBackground)
        .foregroundColor(.primary)
    }
}
