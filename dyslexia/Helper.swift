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

extension Color {
    static let pastelBlue = Color(red: 0.69, green: 0.87, blue: 0.90)
    static let pastelGray = Color(red: 0.93, green: 0.93, blue: 0.93)
}
