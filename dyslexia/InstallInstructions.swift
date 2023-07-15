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
        (Image("Democon"), "Lexy"),
        (Image("KeyboardIcon"), "Keyboards"),
        (Image("ToggleIcon"), "Enable Lexy"),
        (Image("ToggleIcon"), "Allow Full Access"),
        (Image(systemName: "return"), "Come back here!")
    ]
    
    var body: some View {
        VStack {
            
            Text("Enable Lexy")
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
                        .frame(width: 40, height: 40)
                        .foregroundColor(.pastelBlue)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text(text)
                            .font(.body)
                            .strikethrough(isDone)
                        if text == "Allow Full Access" {
                            Text("We _only_ read what you ask us to rewrite, and _never_ store anything.")
                                .font(.caption2)
                        }
                    }
                    Spacer()
                    if text == "Lexy" {
                        Button("Take me there", action: {
                            Helper.openAppSettings()
                        })
                        .buttonStyle(.borderedProminent)
                        .shadow(color: .gray, radius: 3, x: 0, y: 1)

                    }
                   
                }
                .opacity(isDone ? 0.4 : 1)
                .grayscale(isDone ? 1.0 : 0)
        }
    }
    
//    func requestMicPermissions() {
//        let audioSession = AVAudioSession.sharedInstance()
//        audioSession.requestRecordPermission { granted in
//            if granted {
//                print("Mic permissions granted")
//            } else {
//                print("Mic permissions denied")
//                // TODO: Add microphone access todo if they don't grant it, deeplinked into settings
//            }
//        }
//    }
    
    struct InstallInstructions_Previews: PreviewProvider {
        static var previews: some View {
            InstallInstructions(isFullAccessEnabled: false, isKeyboardEnabled: false)
        }
    }
}
