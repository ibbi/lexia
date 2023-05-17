//
//  InstallInstructions.swift
//  dyslexia
//
//  Created by ibbi on 5/10/23.
//

import SwiftUI

struct InstallInstructions: View {
    let isOnlyMissingFullAccess: Bool
    
    let installTodos: [(image: Image, text: String)] = [
        (Image("SettingsIcon"), "Go to settings"),
        (Image(systemName: "app.gift.fill"), "Lexia"),
        (Image("KeyboardIcon"), "Keyboards"),
        (Image("ToggleIcon"), "Enable Lexia"),
        (Image("ToggleIcon"), "Allow Full Access"),
        (Image(systemName: "return"), "Come back here!")
    ]
    
    var body: some View {
        VStack {

            Text(isOnlyMissingFullAccess ? "You're missing Full Access!" : "Enable Lexia")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(0..<installTodos.count, id: \.self) { index in
                    TodoItem(index: index, image: installTodos[index].image, text: installTodos[index].text, isOnlyMissingFullAccess: isOnlyMissingFullAccess)
                        .frame(height: 60)
                        .padding(.horizontal)
                }
            }
            .listStyle(PlainListStyle())

//            Button("Take me to settings", action: {
//                Helper.openAppSettings()
//            })
//            .padding()
//            .background(Color.pastelBlue)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            .padding(.horizontal)
//            .shadow(color: .gray, radius: 5, x: 0, y: 2)
//        }
    }
}

struct TodoItem: View {
    let index: Int
    let image: Image
    let text: String
    let isOnlyMissingFullAccess: Bool

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
                .foregroundColor(isOnlyMissingFullAccess && text == "Allow Full Access" ? Color.red.opacity(0.8) : Color.primary)
            Spacer()
            if text == "Lexia" {
                Button("Just take me there", action: {
                    Helper.openAppSettings()
                })
                .padding(8)
                .background(Color.pastelBlue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
            }
        }
    }
}

struct InstallInstructions_Previews: PreviewProvider {
    static var previews: some View {
        InstallInstructions(isOnlyMissingFullAccess: false)
    }
}

