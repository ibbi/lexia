//
//  KeyboardActionHandler.swift
//  LexiaKeyboard
//
//  Created by ibbi on 4/15/23.
//

import KeyboardKit
import UIKit

class KeyboardActionHandler: StandardKeyboardActionHandler {
    
    override func action(
        for gesture: KeyboardGesture,
        on action: KeyboardAction
    ) -> KeyboardAction.GestureAction? {
        let standard = super.action(for: gesture, on: action)
        
        
        switch gesture {
        case .release:
            return releaseAction(for: action) ?? standard
        default:
            return standard
        }
    }
    
    
    func releaseAction(for action: KeyboardAction) -> KeyboardAction.GestureAction? {
        switch action {
        case .custom(named: "lexia"):
            if let t = textDocumentProxy.selectedText {
                textDocumentProxy.insertText("you highlighted " + t)
            }
            
            let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")
            let transcriptionURL = sharedContainerURL?.appendingPathComponent("transcription.txt")
            
            do {
                let storedTranscription = try String(contentsOf: transcriptionURL!, encoding: .utf8)
                textDocumentProxy.insertText(storedTranscription)
            } catch {
                print("Error: \(error)")
                textDocumentProxy.insertText("yo sup")
            }
            
            return nil
        default:
            return nil
        }
    }
    
}


