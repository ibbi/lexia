//
//  ContentView.swift
//  dyslexia
//
//  Created by ibbi on 4/17/23.
//

import SwiftUI
import KeyboardKit

struct ContentView: View {
    @StateObject private var keyboardState = KeyboardEnabledState(bundleId: "ibbi.dyslexia.*")
    @State private var deeplinkedURL: String?
    @StateObject private var audioRecorder = AudioRecorder()
    
    var body: some View {
        Group {
            if deeplinkedURL == Deeplinks.transcribe.path {
                DictationWhisper(isEdit: false, deeplinkedURL: $deeplinkedURL)
            }
            else if deeplinkedURL == Deeplinks.edit.path {
                DictationWhisper(isEdit: true, deeplinkedURL: $deeplinkedURL)
            }
            else if !keyboardState.isKeyboardEnabled || !keyboardState.isFullAccessEnabled {
                InstallInstructions(isFullAccessEnabled: keyboardState.isFullAccessEnabled, isKeyboardEnabled: keyboardState.isKeyboardEnabled)
            }
            else {
                Playground(isKeyboardActive: keyboardState.isKeyboardActive)
            }
        }
        .onOpenURL { url in
            guard let host = url.host else { return }
            switch host {
            case Deeplinks.inAppTranscribe.path:
                audioRecorder.startRecording(shouldJumpBack: false, isEdit: false)
            case Deeplinks.inAppEdit.path:
                audioRecorder.startRecording(shouldJumpBack: false, isEdit: true)
            default:
                deeplinkedURL = host
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
