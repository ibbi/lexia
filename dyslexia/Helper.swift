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


class Helper{

    static func openAppSettings() {
        // Create the URL that deep links to your app's custom settings.
        if let url = URL(string: UIApplication.openSettingsURLString) {
            // Ask the system to open that URL.
            UIApplication.shared.open(url)
        }
    }
    static func jumpBackToPreviousApp() -> Bool {
        let based = "TFNBcHBsaWNhdGlvbldvcmtzcGFjZQ=="
        guard let data = Data(base64Encoded: based), let dStr = String(data: data, encoding: .utf8) else {
            return false
        }
        if #available(iOS 17.0, *) {
            let sharedDefaults = UserDefaults(suiteName: "group.lexia")
            let lastAppBundleId = sharedDefaults?.string(forKey: "last_app_bundle_id")
            guard let obj = objc_getClass(dStr) as? NSObject else { return false }
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
