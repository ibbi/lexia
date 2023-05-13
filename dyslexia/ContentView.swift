//
//  ContentView.swift
//  dyslexia
//
//  Created by ibbi on 4/17/23.
//

import SwiftUI

struct ContentView: View {
    @State private var shouldShowInstallFlow: Bool = !Helper.isLexiaInstalled()
    
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
            shouldShowInstallFlow = !Helper.isLexiaInstalled()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            shouldShowInstallFlow = !Helper.isLexiaInstalled()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
