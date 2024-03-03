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
        if #available(iOS 17.0, *) {
            return false
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
