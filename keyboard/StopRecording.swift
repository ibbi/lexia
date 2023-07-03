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
        Button(action: {
            let sharedDefaults = UserDefaults(suiteName: "group.lexia")
            sharedDefaults?.set(true, forKey: "stopping_recording")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sharedDefaults?.set(false, forKey: "recording")
            }
        }) {
            VStack{
                Spacer()
                Image("Stop")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.bottom)
                Text("Tap when you're done talking")
                Spacer()
                
            }
            // TODO: Make height not hardcorded
            .frame(maxWidth: .infinity, idealHeight: 216)
        }
            .padding()
            .background(Color.pastelBlue)
    }
}
//struct StopRecordingAndTranscribe_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscribeButton()
//    }
//}

