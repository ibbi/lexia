//
//  KeyboardAppearance.swift
//  LexiaKeyboard
//
//  Created by ibbi on 4/15/23.
//

import KeyboardKit
import SwiftUI

class KeyboardAppearance: StandardKeyboardAppearance {
    override func buttonImage(for action: KeyboardAction) -> Image? {
        if action == .keyboardType(.emojis) { return nil }
        return super.buttonImage(for: action)
    }
    override func buttonText(for action: KeyboardAction) -> String? {
        if action == .keyboardType(.emojis) { return "🤯" }
        return super.buttonText(for: action)
    }
    
    override func buttonStyle(
        for action: KeyboardAction,
        isPressed: Bool
    ) -> KeyboardButtonStyle {
        var style = super.buttonStyle(for: action, isPressed: isPressed)
        style.cornerRadius = 15
        style.backgroundColor = action.isSystemAction ? .yellow : .blue
        style.foregroundColor = action.isSystemAction ? .blue : .yellow
        return style
    }
}

