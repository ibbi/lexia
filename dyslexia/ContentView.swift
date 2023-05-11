//
//  ContentView.swift
//  dyslexia
//
//  Created by ibbi on 4/17/23.
//

import SwiftUI

struct ContentView: View {
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
//            Helper.saveShouldShowInstallFlow(Helper.isLexiaInstalled())
            shouldShowInstallFlow = Helper.getShouldShowInstallFlow()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
