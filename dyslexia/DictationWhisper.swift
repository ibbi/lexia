//
//  DictationWhisper.swift
//  dyslexia
//
//  Created by ibbi on 6/13/23.
//

import SwiftUI
import AVFoundation

struct DictationWhisper: View {
    @State private var transcription: String?
    let isEdit: Bool
    
    @StateObject private var audioRecorder = AudioRecorder()
    @Environment(\.scenePhase) private var scenePhase

    
    var body: some View {
        VStack {
            VStack {
                if let transcription = transcription {
                    Text(transcription)
                }
            }
            .padding()
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                audioRecorder.startRecording(shouldJumpBack: true, isEdit: isEdit)
            }
        }
    }
}

struct DictationWhisper_Previews: PreviewProvider {
    static var previews: some View {
        DictationWhisper(isEdit: false)
    }
}
