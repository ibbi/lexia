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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
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

enum Coachy {

    case selectLexy
    case dictate
    case edit
    case zapSelect
    case zap
    case undo
    
    var lowerText: [String: String] {
        switch self {
        case .selectLexy: return ["subText": "", "tipText": ""]
        case .dictate: return ["subText": "Try saying 'I hate the smell of butter!'", "tipText": ""]
        case .edit: return ["subText": "Try saying 'Make this more aggressive, and all caps", "tipText": "Tip: You can partially edit text by selecting it first"]
        case .zapSelect: return ["subText": "Try selecting \(ZapOptions.rasta.icon) \(ZapOptions.rasta.description)", "tipText": "Tip: We always remember your last voice"]
        case .zap: return ["subText": "", "tipText": "Tip: This is only available when there is text around the cursor"]
        case .undo: return ["subText": "We only remember your last edit, and delete older data", "tipText": "Tip: This only works if you haven't done anything else \nsince the last edit"]
        }
    }
    
    var mainText: Text {
        switch self {
        case .selectLexy: return Text("Hold \(Image(systemName: "globe")) below, and select Lexy")
        case .dictate: return Text("Tap \(Image(systemName: "mic.fill")) to dictate, in any language.")
        case .edit: return Text("Tap \(Image(systemName: "waveform.and.mic")) to make custom voice edits.")
        case .zapSelect: return Text("Tap ⋮ to select a voice.")
        case .zap: return Text("Now tap \(ZapOptions.getZapMode(from: UserDefaults(suiteName: "group.lexia")?.string(forKey: "zap_mode_id") ?? "0")?.icon ?? ZapOptions.rasta.icon) to rewrite in the selected voice.")
        case .undo: return Text("Tap \(Image(systemName: "arrow.counterclockwise")) to undo your most recent edit")
        }
    }
    
    var arrowPosition: CGFloat {
        let buttonWidth = 58.0
        let padding = 14.0
        switch self {
        case .selectLexy: return 0
        case .dictate: return (buttonWidth / 2) - padding + 3
        case .edit: return UIScreen.main.bounds.width - (buttonWidth * 1.5) - padding
        case .zapSelect: return UIScreen.main.bounds.width - (buttonWidth * 3) - padding
        case .zap: return UIScreen.main.bounds.width - (buttonWidth * 2.5) - padding
        case .undo: return UIScreen.main.bounds.width - (buttonWidth/2) - padding - 3
        }
    }
}

enum Deeplinks {
    case transcribe
    case edit
    case inAppTranscribe
    case inAppEdit
    
    var path: String {
        switch self {
        case .transcribe: return "dictation"
        case .edit: return "edit_dictation"
        case .inAppTranscribe: return "dictation_inapp"
        case .inAppEdit: return "edit_dictation_inapp"
        }
    }

    var URL: String {
        let prefix = "dyslexia://"
        return prefix + path
    }
}
