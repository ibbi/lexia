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
    static let pastelGreen = Color(red: 0.60, green: 0.88, blue: 0.65)
}

struct SizeCalculator: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
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
    case grammar
    case clear
    case warm
    case rasta
    case medieval
    case pirate
    
    var id: String {
        switch self {
        case .grammar: return "0"
        case .clear: return "1"
        case .warm: return "2"
        case .rasta: return"3"
        case .medieval: return"4"
        case .pirate: return"5"
        }
    }
    var icon: String {
        switch self {
        case .grammar: return "⚡️"
        case .clear: return "🫡"
        case .rasta: return "🇯🇲"
        case .medieval: return"🏰"
        case .warm: return "👔"
        case .pirate: return "🏴‍☠️"
        }
    }
    var description: String {
        switch self {
        case .clear: return "Clear, concise"
        case .warm: return "Warm, professional"
        case .rasta: return "Rastafarian"
        case .medieval: return "Old timey"
        case .grammar: return "Grammar, spelling"
        case .pirate: return "Pirate"
        }
    }
    static func getZapMode(from id: String) -> ZapOptions? {
        switch id {
        case ZapOptions.clear.id: return .clear
        case ZapOptions.warm.id: return .warm
        case ZapOptions.rasta.id: return .rasta
        case ZapOptions.medieval.id: return .medieval
        case ZapOptions.grammar.id: return .grammar
        case ZapOptions.pirate.id: return .pirate
        default: return nil
        }
    }
}

enum Coachy {

    case selectLexi
    case dictate
    case edit
    case zapSelect
    case zap
    case editMode
    case confirm
    
    var lowerText: [String: String] {
        switch self {
        case .selectLexi: return ["subText": "", "tipText": ""]
        case .dictate: return ["subText": "Try saying 'Are you crazy? That makes no sense.'", "tipText": ""]
        case .zapSelect: return ["subText": "Try selecting \(ZapOptions.warm.icon) \(ZapOptions.warm.description)", "tipText": "Tip: We always remember your last voice"]
        case .zap: return ["subText": "", "tipText": "Tip: Editing is unavailable when there\nis no text around the cursor"]
        case .edit: return ["subText": "Try saying 'Make this rhyme, and all caps'", "tipText": "Tip: You can partially edit text by selecting it first"]
        case .editMode: return ["subText": "The selected text, or the text around your cursor\nmoves with you", "tipText": "Tip: Use Longform to iterate"]
        case .confirm: return ["subText": "We will try to replace your older text with the new text", "tipText": "Tip: If we can't figure out what text to replace,\nwe put it on your clipboard"]
        }
    }
    
    var mainText: Text {
        switch self {
        case .selectLexi: return Text("Hold \(Image(systemName: "globe")) below, and select Lexi")
        case .dictate: return Text("Tap \(Image(systemName: "mic.fill")) to dictate, in any language")
        case .zapSelect: return Text("Tap \(Image(systemName: "arrowtriangle.down.fill")) to select a voice")
        case .zap: return Text("Tap \(ZapOptions.getZapMode(from: UserDefaults(suiteName: "group.lexia")?.string(forKey: "zap_mode_id") ?? "0")?.icon ?? ZapOptions.medieval.icon) to become professional")
        case .edit: return Text("Tap \(Image(systemName: "waveform.and.mic")) to make custom voice edits")
        case .editMode: return Text("Tap \(Image(systemName: "rectangle.and.text.magnifyingglass")) to move your text to Longform")
        case .confirm: return Text("Play around, then tap \(Image(systemName: "checkmark.circle.fill")) to confirm")
        }
    }
    
    var arrowPosition: CGFloat {
        let buttonWidth = 58.0
        let padding = 17.0
        switch self {
        case .selectLexi: return 0
        case .dictate: return (buttonWidth / 2) - padding + 6
        case .zapSelect: return UIScreen.main.bounds.width - (buttonWidth * 3.8)
        case .zap: return UIScreen.main.bounds.width - (buttonWidth * 3)
        case .edit: return UIScreen.main.bounds.width - (buttonWidth * 1.9)
        case .editMode: return UIScreen.main.bounds.width - (buttonWidth/2) - padding - 3
        case .confirm: return UIScreen.main.bounds.width - (buttonWidth/2) - padding - 3
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
