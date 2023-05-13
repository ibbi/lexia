//
//  ContentView.swift
//  dyslexia
//
//  Created by ibbi on 4/17/23.
//

import SwiftUI
import KeyboardKit

struct ContentView: View {
    @State private var shouldShowInstallFlow: Bool = !KeyboardEnabledState(bundleId: "ibbi.dyslexia.*").isKeyboardEnabled

    
    var body: some View {
        Group {
            if shouldShowInstallFlow {
                InstallInstructions()
            }
            else {
                Playground()
            }
        }
        .onAppear {
            shouldShowInstallFlow = !KeyboardEnabledState(bundleId: "ibbi.dyslexia.*").isKeyboardEnabled
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            shouldShowInstallFlow = !KeyboardEnabledState(bundleId: "ibbi.dyslexia.*").isKeyboardEnabled
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
