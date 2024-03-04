//
//  DictationWhisper.swift
//  dyslexia
//
//  Created by ibbi on 6/13/23.
//

import SwiftUI
import AVFoundation

struct DictationWhisper: View {
    let isEdit: Bool
    @Binding var deeplinkedURL: String?
    
    @StateObject private var audioRecorder = AudioRecorder()
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) var colorScheme // Access the current color scheme

    var body: some View {
        VStack {
            HStack {
                // Conditionally display the image based on the color scheme
                if colorScheme == .dark {
                    Image("ArrowTL") // Use this image in dark mode
                } else {
                    Image("ArrowTLL") // Use this image in light mode
                }
                Text("Tap here to go back")
                    .font(.title2)
                    .padding(.top)
                Spacer()
            }
            .padding(.leading, 25)
            Spacer()
            Text("Sorry for the inconvenience, Apple forced me to do this")
                .padding()
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                audioRecorder.startRecording(shouldJumpBack: true, isEdit: isEdit)
                if #available(iOS 17, *) {
                    // For iOS 17 and later, reset "deeplinkedURL" when the app is dismissed
                    NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
                        deeplinkedURL = ""
                    }
                } else {
                    // For iOS versions before 17, reset "deeplinkedURL" after 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        deeplinkedURL = ""
                    }
                }
            }
        }
    }
}
