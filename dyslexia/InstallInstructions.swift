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
        (Image("Democon"), "Lexi"),
        (Image("ToggleIcon"), "Microphone"),
        (Image("KeyboardIcon"), "Keyboards"),
        (Image("ToggleIcon"), "Enable Lexi"),
        (Image("ToggleIcon"), "Allow Full Access"),
        (Image(systemName: "return"), "Come back here!")
    ]
    
    func isDone(index: Int) -> Bool {
        switch index {
        case 0, 1: return isKeyboardEnabled && AVAudioSession.sharedInstance().recordPermission == .granted
        case 2: return AVAudioSession.sharedInstance().recordPermission == .granted
        case 3, 4: return isKeyboardEnabled
        case 5: return isFullAccessEnabled
        default: return false
        }
    }
    
    var body: some View {
        VStack {
            
            Text("Enable Lexi")
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(0..<installTodos.count, id: \.self) { index in
                    TodoItem(index: index, image: installTodos[index].image, text: installTodos[index].text, isDone: isDone(index: index), isButtonDisabled: isKeyboardEnabled && isFullAccessEnabled)
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
        let isButtonDisabled: Bool
        
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
                    if text == "Lexi" {
                        Button("Take me there", action: {
                            Helper.openAppSettings()
                        })
                        .buttonStyle(.borderedProminent)
                        .disabled(isButtonDisabled)
                    }
                   
                }
                .opacity(isDone ? 0.4 : 1)
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
    
    struct InstallInstructions_Previews: PreviewProvider {
        static var previews: some View {
            InstallInstructions(isFullAccessEnabled: false, isKeyboardEnabled: true)
        }
    }
}
