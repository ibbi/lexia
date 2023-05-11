//
//  Helpers.swift
//  dyslexia
//
//  Created by ibbi on 5/6/23.
//

import Foundation
import UIKit


class Helper{
    
    static let shouldShowInstallFlowKey = "ShouldShowInstallFlow"

        static func saveShouldShowInstallFlow(_ value: Bool) {
            UserDefaults.standard.set(value, forKey: shouldShowInstallFlowKey)
        }

        static func getShouldShowInstallFlow() -> Bool {
            if UserDefaults.standard.object(forKey: shouldShowInstallFlowKey) == nil {
                saveShouldShowInstallFlow(!isLexiaInstalled())
                return !isLexiaInstalled()
            } else {
                return UserDefaults.standard.bool(forKey: shouldShowInstallFlowKey)
            }
        }

    static func isLexiaInstalled() -> Bool {
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
}
