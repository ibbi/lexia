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
    
    var body: some View {
//        DictationWhisper()
        Group {
            if deeplinkedURL == "dictation" {
                DictationWhisper()
            }
            else if !keyboardState.isKeyboardEnabled || !keyboardState.isFullAccessEnabled {
                InstallInstructions(isOnlyMissingFullAccess: !keyboardState.isFullAccessEnabled && keyboardState.isKeyboardEnabled)
            }
            else {
                Playground(isKeyboardActive: keyboardState.isKeyboardActive)
            }
        }
        .onOpenURL { url in
            guard let host = url.host else { return }
            deeplinkedURL = host
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
