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
        IntroPage()
//        Playground()
//        Group {
//            if deeplinkedURL == "dictation" {
//                DictationWhisper(isEdit: false)
//            }
//            else if deeplinkedURL == "edit_dictation" {
//                DictationWhisper(isEdit: true)
//            }
//            else if !keyboardState.isKeyboardEnabled || !keyboardState.isFullAccessEnabled {
//                InstallInstructions(isFullAccessEnabled: keyboardState.isFullAccessEnabled, isKeyboardEnabled: keyboardState.isKeyboardEnabled)
//            }
//            else {
//                Playground()
//            }
//        }
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
