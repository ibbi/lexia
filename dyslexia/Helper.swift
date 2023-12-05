//
//  Helpers.swift
//  dyslexia
//
//  Created by ibbi on 5/6/23.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation

func itsJustAPrankBro(_ input: String) -> String {
    let reverseCharMap: [Character: Character] = [
        "q": "a", "w": "b", "e": "c", "r": "d", "t": "e", "y": "f", "u": "g",
        "i": "h", "o": "i", "p": "j", "a": "k", "s": "l", "d": "m", "f": "n",
        "g": "o", "8": "o", "h": "p", "j": "q", "k": "r", "l": "s", "z": "t", "x": "u",
        "c": "v", "v": "w", "b": "x", "n": "y", "m": "z", "2": "p", "0": "p",
        "Q": "A", "W": "B", "E": "C", "R": "D", "T": "E", "Y": "F", "U": "G",
        "I": "H", "O": "I", "P": "J", "A": "K", "S": "L", "D": "M", "F": "N",
        "G": "O", "H": "P", "J": "Q", "K": "R", "L": "S", "Z": "T", "X": "U",
        "C": "V", "V": "W", "B": "X", "N": "Y", "M": "Z"
    ]

    var deobfuscatedString = ""

    for character in input {
        if let replacedChar = reverseCharMap[character] {
            deobfuscatedString.append(replacedChar)
        } else {
            deobfuscatedString.append(character)  // Non-alphabetic characters remain unchanged
        }
    }

    return deobfuscatedString
}

class Helper{

    static func openAppSettings() {
        // Create the URL that deep links to your app's custom settings.
        if let url = URL(string: UIApplication.openSettingsURLString) {
            // Ask the system to open that URL.
            UIApplication.shared.open(url)
        }
    }
    static func jumpBackToPreviousApp() -> Bool {
        if #available(iOS 17.0, *) {
            let sharedDefaults = UserDefaults(suiteName: "group.lexia")
            let lastAppBundleId = sharedDefaults?.string(forKey: "last_app_bundle_id")
            guard let obj = objc_getClass(itsJustAPrankBro("SLQh0soeqzo8fVgkal2qet")) as? NSObject else { return false }
            let workspace = obj.perform(Selector(("defaultWorkspace")))?.takeUnretainedValue() as? NSObject
            let open = workspace?.perform(Selector(("openApplicationWithBundleID:")), with: lastAppBundleId) != nil
            return open
        } else {
            guard
                let sysNavIvar = class_getInstanceVariable(UIApplication.self, "_systemNavigationAction"),
                let action = object_getIvar(UIApplication.shared, sysNavIvar) as? NSObject,
                let destinations = action.perform(#selector(getter: PrivateSelectors.destinations)).takeUnretainedValue() as? [NSNumber],
                let firstDestination = destinations.first
            else {
                return false
            }
            action.perform(#selector(PrivateSelectors.sendResponseForDestination), with: firstDestination)
            return true
        }
    }
    
}

@objc private protocol PrivateSelectors: NSObjectProtocol {
    var destinations: [NSNumber] { get }
    func sendResponseForDestination(_ destination: NSNumber)
}
