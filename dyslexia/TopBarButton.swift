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
            case .edit: return Image(systemName: "pencil")
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
    
    var disabledIcon: Image {
        switch self {
            case .speak: return Image(systemName: "mic.slash.fill")
            case .edit: return Image(systemName: "pencil.slash")
            case .enhance: return Image(systemName: "bolt.slash.fill")
            case .undo: return Image(systemName: "arrow.counterclockwise")
        }
    }
}

struct TopBarButton: View {
    var buttonType: ButtonType
    var action: (() -> Void)?
    @Binding var isLoading: Bool
    let onlyVisual: Bool
    let isInBadContext: Bool

    var body: some View {
        Button(action: {
//            isLoading = true
            action!()
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 25, height: 25, alignment: .center)

                } else if isInBadContext {
                    buttonType.disabledIcon
                        .imageScale(.large)
                        .frame(width: 25, height: 25, alignment: .center)
                    
                } else {
                    buttonType.icon
                        .imageScale(.large)
                        .frame(width: 25, height: 25, alignment: .center)

                }
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.standardButtonBackground)
        .foregroundColor(.primary)
        .disabled(isLoading || onlyVisual || isInBadContext)
        }
    }



struct TopBarButton_Previews: PreviewProvider {
    static var previews: some View {
        TopBarButton(buttonType: ButtonType.edit, action: {}, isLoading: .constant(false), onlyVisual: false, isInBadContext: false)
    }
}
