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
            return { _ in  }
        default:
            return nil
        }
    }
    
}


