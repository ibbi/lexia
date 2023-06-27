//
//  KeyboardView.swift
//  keyboard
//
//  Created by ibbi on 5/15/23.
//

import SwiftUI
import KeyboardKit

struct KeyboardView: View {
    unowned var controller: KeyboardInputViewController
    @EnvironmentObject
    private var keyboardContext: KeyboardContext
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false
    @State private var recentTranscription: String = ""


    var body: some View {
        VStack(spacing: 0) {
            if isRecording {
                StopRecording()
            } else {
                HStack {
                    TranscribeButton(controller: controller, recentTranscription: $recentTranscription)
                    RewriteButton(controller: controller, recentTranscription: $recentTranscription)
                }
                SystemKeyboard(
                    controller: controller,
                    autocompleteToolbar: .none
                )
                .background(Color.pastelBlue)
            }
        }
    }
}

//struct KeyboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeyboardView()
//    }
//}
