//
//  TranscribeButton.swift
//  dyslexia
//
//  Created by ibbi on 5/15/23.
//

import SwiftUI
import KeyboardKit

struct PulsingCircle: View {
    @State var scale = 1.0

    var body: some View {
        Circle()
            .frame(width: 80, height: 80)
            .scaleEffect(scale)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 1.5)
                let repeated = baseAnimation.repeatForever(autoreverses: true)

                withAnimation(repeated) {
                    scale = 1.5
                }
            }
            .foregroundColor(.secondary)
    }
}

struct StopRecording: View {
    let sharedDefaults = UserDefaults(suiteName: "group.lexia")
    @State private var isUserDismissing = false
    var body: some View {
        Button(action: {
            isUserDismissing = true
            sharedDefaults?.set(true, forKey: "stopping_recording")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                sharedDefaults?.set(false, forKey: "recording")
            }
        }) {
            VStack{
                HStack {
                    Button(action: {
                        isUserDismissing = true
                        sharedDefaults?.set(true, forKey: "discard_recording")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            sharedDefaults?.set(false, forKey: "recording")
                        }                    }) {
                        Text("Discard")
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                Spacer()
                ZStack {
                    PulsingCircle()
                        .ignoresSafeArea()
                    Image(systemName: "mic.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .foregroundColor(.primary)
                }
                .padding(.bottom)
                Text("Tap when you're done talking")
                    .foregroundColor(.primary)
                Spacer()
                
            }
            // TODO: Make height not hardcorded
            .frame(maxWidth: .infinity, idealHeight: 216)
        }
            .padding()
            .onDisappear{
                if (isUserDismissing) {
                    isUserDismissing = false
                }
                else {
                    sharedDefaults?.set(true, forKey: "discard_recording")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        sharedDefaults?.set(false, forKey: "recording")
                    }
                }
            }
    }
}
//struct StopRecordingAndTranscribe_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscribeButton()
//    }
//}

