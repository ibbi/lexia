//
//  InstallInstructions.swift
//  dyslexia
//
//  Created by ibbi on 5/10/23.
//

import SwiftUI
import AVFoundation

struct InstallInstructions: View {
    let isFullAccessEnabled: Bool
    let isKeyboardEnabled: Bool
    
    let installTodos: [(image: Image, text: String)] = [
        (Image("SettingsIcon"), "Open Settings"),
        (Image(systemName: "app.gift.fill"), "Lexia"),
        (Image("Micon"), "Keyboards"),
        (Image("ToggleIcon"), "Enable Lexia"),
        (Image("ToggleIcon"), "Allow Full Access"),
        (Image(systemName: "return"), "Come back here!")
    ]
    
    var body: some View {
        VStack {
            
            Text("Enable Lexia")
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(0..<installTodos.count, id: \.self) { index in
                    TodoItem(index: index, image: installTodos[index].image, text: installTodos[index].text, isDone: (index < 4 && isKeyboardEnabled) || index == 4 && isFullAccessEnabled )
                        .frame(height: 60)
                        .padding(.horizontal)
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear(perform: requestMicPermissions)
    }
    
    struct TodoItem: View {
        let index: Int
        let image: Image
        let text: String
        let isDone: Bool
        
        var body: some View {
            HStack {
                Text("\(index + 1)")
                    .font(.headline)
                    .padding(.trailing)
                image
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.pastelBlue)
                Text(text)
                    .font(.body)
                    .strikethrough(isDone)
                Spacer()
                if text == "Lexia" {
                    Button("Take me there", action: {
                        Helper.openAppSettings()
                    })
                    .padding(8)
                    .background(Color.pastelBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    .disabled(isDone)
                }
            }
            .opacity(isDone ? 0.4 : 1)
            .grayscale(isDone ? 1.0 : 0)
        }
    }
    
    func requestMicPermissions() {
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { granted in
            if granted {
                print("Mic permissions granted")
            } else {
                print("Mic permissions denied")
                // TODO: Add microphone access todo if they don't grant it, deeplinked into settings
            }
        }
    }
    
//    struct InstallInstructions_Previews: PreviewProvider {
//        static var previews: some View {
//            InstallInstructions(isOnlyMissingFullAccess: false)
//        }
//    }
}
