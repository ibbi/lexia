//
//  File.swift
//  dyslexia
//
//  Created by ibbi on 5/15/23.
//

import Foundation
import SwiftUI

extension Color {
    static let pastelBlue = Color(red: 0.69, green: 0.87, blue: 0.90)
    static let pastelGray = Color(red: 0.93, green: 0.93, blue: 0.93)
    static let pastelYellow = Color(red: 1.00, green: 0.87, blue: 0.51)
    static let pastelRed = Color(red: 1.00, green: 0.66, blue: 0.64)
    static let pastelGreen = Color(red: 0.60, green: 0.88, blue: 0.85)
}

enum ZapOptions: CaseIterable {
    case casual
    case professional
    case rasta
    case medieval
    
    var id: String {
        switch self {
        case .casual: return "0"
        case .professional: return "1"
        case .rasta: return "2"
        case .medieval: return"3"
        }
    }
    var icon: String {
        switch self {
        case .casual: return "⚡️"
        case .professional: return "👔"
        case .rasta: return "🇯🇲"
        case .medieval: return"🏰"
        }
    }
    var description: String {
        switch self {
        case .casual: return "Casual, concise"
        case .professional: return "Precise, professional"
        case .rasta: return "Rastafarian"
        case .medieval: return"Old timey"
        }
    }
    static func getZapMode(from id: String) -> ZapOptions? {
        switch id {
        case ZapOptions.casual.id: return .casual
        case ZapOptions.professional.id: return .professional
        case ZapOptions.rasta.id: return .rasta
        case ZapOptions.medieval.id: return .medieval
        default: return nil
        }
    }
}
