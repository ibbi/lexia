//
//  InstallInstructions.swift
//  dyslexia
//
//  Created by ibbi on 5/10/23.
//

import SwiftUI

struct InstallInstructions: View {
    
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

            Text("Enable Lexia")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(0..<installTodos.count, id: \.self) { index in
                    TodoItem(index: index, image: installTodos[index].image, text: installTodos[index].text)
                }
            }

            Button("Take me to settings", action: {
                Helper.openAppSettings()
            })
            .padding()
        }
    }
}

struct TodoItem: View {
    let index: Int
    let image: Image
    let text: String

    var body: some View {
        HStack {
            Text("\(index + 1)")
            image
            Text(text)
            if text == "Lexia" {
                Button("Just take me there", action: {
                    Helper.openAppSettings()
                })
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue))
            }
        }
    }
}


struct InstallInstructions_Previews: PreviewProvider {
    static var previews: some View {
        InstallInstructions()
    }
}
