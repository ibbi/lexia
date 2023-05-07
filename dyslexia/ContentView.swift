//
//  ContentView.swift
//  dyslexia
//
//  Created by ibbi on 4/17/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isKeyboardExtensionEnabled: Bool = Helper.isKeyboardExtensionEnabled()
    
    var body: some View {
        Group {
            if isKeyboardExtensionEnabled {
                Intructions2()
            } else {
                Intructions1()
            }
        }
        .onAppear {
            updateState()
        }
    }
    func updateState() {
            isKeyboardExtensionEnabled = Helper.isKeyboardExtensionEnabled()
        }
    
}

struct Intructions1: View {
    let items: [(image: Image, text: String)] = [
        (Image("SettingsIcon"), "Go to settings"),
        (Image("SettingsIcon"), "Lexia"),
        (Image("KeyboardIcon"), "Keyboards"),
        (Image("ToggleIcon"), "Enable Lexia"),
        (Image("ToggleIcon"), "Allow Full Access"),
        (Image(systemName: "diamond.fill"), "Come back here to finish installing")
    ]

    var body: some View {
        VStack {
            // Header text
            Text("Enable Lexia")
                .font(.largeTitle)
                .padding()

            // Vertical list of HStack items
            List {
                ForEach(0..<items.count, id: \.self) { index in
                    TodoItem(index: index, image: items[index].image, text: items[index].text)
                }
            }

            // Button at the end
            Button("Button", action: {
                print("Button tapped")
            })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
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
                Button("Take me there", action: {
                    Helper.openAppSettings()
                })
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue))
            }
        }
    }
}

struct Intructions2: View {
    let items: [(image: Image, text: String)] = [
        (Image("SettingsIcon"), "Tap the globe icon"),
        (Image("SettingsIcon"), "Select Lexia"),
    ]

    var body: some View {
        VStack {
            // Header text
            Text("Select Lexia")
                .font(.largeTitle)
                .padding()

            // Vertical list of HStack items
            List {
                ForEach(0..<items.count, id: \.self) { index in
                    TodoItem(index: index, image: items[index].image, text: items[index].text)
                }
            }

            // Button at the end
            Button("Button", action: {
                print("Button tapped")
            })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
