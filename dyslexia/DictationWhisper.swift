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

    
    var body: some View {
        VStack {
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                audioRecorder.startRecording(shouldJumpBack: true, isEdit: isEdit)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    deeplinkedURL = ""
                }
            }
        }
    }
}
