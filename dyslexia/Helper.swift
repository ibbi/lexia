//
//  Helpers.swift
//  dyslexia
//
//  Created by ibbi on 5/6/23.
//

import Foundation
import UIKit
import SwiftUI


class Helper{

    static func openAppSettings() {
        // Create the URL that deep links to your app's custom settings.
        if let url = URL(string: UIApplication.openSettingsURLString) {
            // Ask the system to open that URL.
            UIApplication.shared.open(url)
        }
    }
}

@objc private protocol PrivateSelectors: NSObjectProtocol {
    var destinations: [NSNumber] { get }
    func sendResponseForDestination(_ destination: NSNumber)
}

func jumpBackToPreviousApp() -> Bool {
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

