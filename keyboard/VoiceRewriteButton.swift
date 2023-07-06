//
//  VoiceRewriteButton.swift
//  keyboard
//
//  Created by ibbi on 7/5/23.
//

import SwiftUI
import KeyboardKit
import Combine
import URLProxy

struct VoiceRewriteButton: View {
    let controller: KeyboardInputViewController
    @Binding var rewrittenText: String
    @Binding var prewrittenText: String
    @Binding var prevContext: String?
    @State private var selectedText: String?
    @State private var isLoading: Bool = false
    @State private var prevText = ""
    @State private var afterText = ""
    @State private var fullText = ""
    @State private var afterTries = 0
    @State var isTranscribing: Bool = false

    let beforeTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    let afterTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    let sharedDefaults = UserDefaults(suiteName: "group.lexia")
    @State private var beforeCancellable: AnyCancellable?
    @State private var afterCancellable: AnyCancellable?
    
    func getAudioURL() -> URL {
        let fileManager = FileManager.default
        let sharedDataPath = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")!
        return sharedDataPath.appendingPathComponent("edit_recording.m4a")
    }

    
    func tryGetContext() {
        let audioURL = getAudioURL()
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: audioURL.path) {
            print("file exists")
            isLoading = true
            decideSelectionOrEntire()
        }
    }
    
    func getTextContextBefore() -> Bool {

        var before = controller.textDocumentProxy.documentContextBeforeInput
        if ((before == nil) || (before!.isEmpty)){
            controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: prevText.count)
            beforeCancellable?.cancel()
            self.afterCancellable = self.afterTimer.sink { _ in
                DispatchQueue.main.async {
                    self.getTextContextAfter()
                }
            }
            return true
        }
        prevText = (before ?? "") + prevText
        var len = (before?.count ?? 0) * -1
        controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: len)
        return false
    }
    
    func getTextContextAfter() -> Bool {
 
        var after = controller.textDocumentProxy.documentContextAfterInput
        if ((after == nil) || (after!.isEmpty)){
            // silly hack because sometimes newlines break this jank thing i wrote lel. It breaks if there are more than 10 unexpected newlines
            if (afterTries < 10) {
                controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
                afterText += "\n"
                afterTries += 1
            } else {
                afterTries = 0
                afterCancellable?.cancel()
                while afterText.hasSuffix("\n") {
                    afterText = String(afterText.dropLast())
                }
                fullText = prevText + afterText
                afterText = ""
                prevText = ""
                return true
            }
        }
        afterText = afterText + (after ?? "")
        var len = (after?.count ?? 0)
        controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: len)
        return false
    }


    func rewriteTextWithAudioInstructions(_ text: String, shouldDelete: Bool) {
        let audioURL = getAudioURL()
        prewrittenText = text
        
        API.sendAudioAndText(audioURL: audioURL, contextText: text) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let transformed):
                    if shouldDelete {
                        controller.textDocumentProxy.deleteBackward(times: text.count)
                    }
                    controller.textDocumentProxy.insertText(transformed)
                    rewrittenText = transformed
                    prevContext = KeyHelper.getFiveSurroundingChars(controller: controller)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                do {
                    let fileManager = FileManager.default
                    try fileManager.removeItem(at: audioURL)
                } catch {
                    print("Error deleting file: \(error)")
                }
            }
        }
    }

    func decideSelectionOrEntire() {
        if let selectedText = controller.keyboardTextContext.selectedText {
            rewriteTextWithAudioInstructions(selectedText, shouldDelete: false)
        } else if controller.textDocumentProxy.documentContext != nil {
            self.beforeCancellable = self.beforeTimer.sink { _ in
                DispatchQueue.main.async {
                    self.getTextContextBefore()
                }
            }
        }
    }
    
    func hasTextToRewrite() -> Bool {
        if let selectedText = controller.keyboardTextContext.selectedText {
            return true
        } else if controller.textDocumentProxy.documentContext != nil {
            return true
        }
        return false
    }

    var body: some View {
        Button(action: {
            if hasTextToRewrite() {
                let urlHandler = URLHandler()
                urlHandler.openURL("dyslexia://edit_dictation")
            }
        }) {
            Text(isLoading ? "Loading..." : "Edit")
        }
        .disabled(isLoading)
        .onChange(of: fullText) { newValue in
            if (!newValue.isEmpty && hasTextToRewrite()) {
                rewriteTextWithAudioInstructions(fullText, shouldDelete: true)
                fullText = ""
            }
        }
        .buttonStyle(.bordered)
        .onAppear{
            tryGetContext()
        }
    }
}

//struct VoiceRewriteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceRewriteButton()
//    }
//}
