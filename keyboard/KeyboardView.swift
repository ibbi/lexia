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
    @State private var isRecording: Bool = false
    private func updateRecordingFlag() {
        let sharedDefaults = UserDefaults(suiteName: "group.lexia")
        isRecording = sharedDefaults?.bool(forKey: "recording") ?? false
    }
    var body: some View {
        VStack(spacing: 0) {
            if isRecording {
                StopRecording()
            } else {
                HStack {
                    TranscribeButton(controller: controller)
                    RewriteButton(controller: controller)
                }
                SystemKeyboard(
                    controller: controller,
                    autocompleteToolbar: .none
                )
                .background(Color.pastelBlue)
            }
        }
        .onAppear {
            updateRecordingFlag()
        }
        .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)) { _ in
            updateRecordingFlag()
        }
    }
}


//struct KeyboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeyboardView()
//    }
//}
