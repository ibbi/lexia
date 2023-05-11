//
//  ContentView.swift
//  dyslexia
//
//  Created by ibbi on 4/17/23.
//

import SwiftUI

struct ContentView: View {
    // Changing permissions relaunches the app, so we need to store the state of install in a proxy UserDefault instead of just state (state would re-initialize)
    @State private var shouldShowInstallFlow: Bool = Helper.getShouldShowInstallFlow()
    
    var body: some View {
        Group {
            if shouldShowInstallFlow {
                InstallInstructions(shouldShowInstallFlow: $shouldShowInstallFlow)
            }
            else {
                Playground()
            }
        }
        .onAppear {
            shouldShowInstallFlow = Helper.getShouldShowInstallFlow()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
