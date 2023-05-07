//
//  Helpers.swift
//  dyslexia
//
//  Created by ibbi on 5/6/23.
//

import Foundation
import UIKit


class Helper{
    static func isLexiaEnabled() -> Bool {
        guard let appBundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("isKeyboardExtensionEnabled(): Cannot retrieve bundle identifier.")
        }

        guard let keyboards = UserDefaults.standard.dictionaryRepresentation()["AppleKeyboards"] as? [String] else {
            // There is no key `AppleKeyboards` in NSUserDefaults. That happens sometimes.
            return false
        }

        let keyboardExtensionBundleIdentifierPrefix = appBundleIdentifier + "."
        for keyboard in keyboards {
            if keyboard.hasPrefix(keyboardExtensionBundleIdentifierPrefix) {
                return true
            }
        }

        return false
    }
    
    static func openAppSettings() {
        // Create the URL that deep links to your app's custom settings.
        if let url = URL(string: UIApplication.openSettingsURLString) {
            // Ask the system to open that URL.
            UIApplication.shared.open(url)
        }
    }
    
    static func isLexiaSelected() -> Bool {
        let inputMode = UIApplication.shared.delegate?.window??.textInputMode
        if inputMode?.responds(to: NSSelectorFromString("identifier")) ?? false {
             let identifier = inputMode?.perform(NSSelectorFromString("identifier")).takeRetainedValue() as? String
            print("identifier as Any")
            print(identifier as Any) // Current keyboard identifier.
        }
        else {print("false")}
        return false
    }
}
