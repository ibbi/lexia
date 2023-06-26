//
//  TranscribeButton.swift
//  dyslexia
//
//  Created by ibbi on 5/15/23.
//

import SwiftUI
import KeyboardKit

struct StopRecording: View {
    var body: some View {
        Button("Write", action: {
            let sharedDefaults = UserDefaults(suiteName: "group.lexia")
            sharedDefaults?.set(true, forKey: "stopping_recording")
        })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pastelBlue)
    }
}
//struct StopRecordingAndTranscribe_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscribeButton()
//    }
//}
