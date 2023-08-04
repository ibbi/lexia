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
    case redo
    case confirm
    case discard
    case editView

    var icon: Image {
        switch self {
        case .speak: return Image(systemName: "mic.fill")
        case .edit: return Image(systemName: "waveform.and.mic")
        case .enhance: return Image(systemName: "bolt.fill")
        case .undo: return Image(systemName: "arrow.uturn.backward")
        case .redo: return Image(systemName: "arrow.uturn.forward")
        case .confirm: return Image(systemName: "checkmark.circle.fill")
        case .discard: return Image(systemName: "trash.fill")
        case .editView: return Image(systemName: "note.text")
        }
    }
    
    var tint: Color {
        switch self {
        case .discard: return .pastelRed
        case .confirm: return .pastelGreen
        default: return .primary
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
        .tint(.standardButtonBackground)
        .foregroundColor(buttonType.tint)
        .disabled(isLoading || isInBadContext)
        }
    }



struct TopBarButton_Previews: PreviewProvider {
    static var previews: some View {
        TopBarButton(buttonType: ButtonType.editView, action: {}, isLoading: .constant(false), isInBadContext: false)
    }
}
