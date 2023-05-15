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


    
    var body: some View {
        Group {
            if !keyboardState.isKeyboardEnabled || !keyboardState.isFullAccessEnabled {
                InstallInstructions(isOnlyMissingFullAccess: !keyboardState.isFullAccessEnabled && keyboardState.isKeyboardEnabled)
            }
            else {
                Playground(isKeyboardActive: keyboardState.isKeyboardActive)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
