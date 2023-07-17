//
//  TopBarButton.swift
//  dyslexia
//
//  Created by ibbi on 7/7/23.
//

import SwiftUI
import KeyboardKit

enum ButtonType {
    case speak
    case edit
    case enhance
    case undo

    var icon: Image {
        switch self {
            case .speak: return Image(systemName: "mic.fill")
            case .edit: return Image(systemName: "waveform.and.mic")
            case .enhance: return Image(systemName: "bolt.fill")
            case .undo: return Image(systemName: "arrow.counterclockwise")
        }
    }
    
    var label: String {
        switch self {
        case .speak: return "Speak"
        case .edit: return "Edit"
        case .enhance: return "Fix"
        case .undo: return ""
        }
    }
    
}

struct TopBarButton: View {
    var buttonType: ButtonType
    var action: (() -> Void)?
    @Binding var isLoading: Bool
    let isInBadContext: Bool

    var body: some View {
        Button(action: {
            isLoading = true
            action!()
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 25, height: 25, alignment: .center)
                } else {
                    ZStack {
                        buttonType.icon
                            .imageScale(.large)
                            .frame(width: 25, height: 25, alignment: .center)
                        Image(systemName: "line.diagonal")
                            .imageScale(.large)
                            .frame(width: 25, height: 25, alignment: .center)
                            .rotationEffect(.degrees(90))
                            .opacity(isInBadContext ? 1 : 0)
                    }
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.standardButtonBackground)
        .foregroundColor(.primary)
        .disabled(isLoading || isInBadContext)
        }
    }



struct TopBarButton_Previews: PreviewProvider {
    static var previews: some View {
        TopBarButton(buttonType: ButtonType.edit, action: {}, isLoading: .constant(false), isInBadContext: false)
    }
}
