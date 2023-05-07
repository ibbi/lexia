//
//  ContentView.swift
//  dyslexia
//
//  Created by ibbi on 4/17/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isLexiaEnabled: Bool = Helper.isLexiaEnabled()
    
    var body: some View {
        Group {
            if isLexiaEnabled {
                PostInstall()
            } else {
                PreInstall()
            }
        }
        .onAppear {
            updateState()
        }
    }
    func updateState() {
        isLexiaEnabled = Helper.isLexiaEnabled()
        }
    
}

struct PreInstall: View {
    let installTodos: [(image: Image, text: String)] = [
        (Image("SettingsIcon"), "Go to settings"),
        (Image("SettingsIcon"), "Lexia"),
        (Image("KeyboardIcon"), "Keyboards"),
        (Image("ToggleIcon"), "Enable Lexia"),
        (Image("ToggleIcon"), "Allow Full Access"),
        (Image(systemName: "return"), "Come back here to finish installing")
    ]
    
    var body: some View {
        VStack {
            // Header text
            Text("Enable Lexia")
                .font(.largeTitle)
                .padding()

            // Vertical list of HStack items
            List {
                ForEach(0..<installTodos.count, id: \.self) { index in
                    TodoItem(index: index, image: installTodos[index].image, text: installTodos[index].text)
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

struct PostInstall: View {
    let items: [(image: Image, text: String)] = [
        (Image("SettingsIcon"), "Tap the globe icon"),
        (Image("SettingsIcon"), "Select Lexia"),
    ]
    
    @FocusState private var isInputFocused: Bool
    @State private var inputText: String = ""

    var body: some View {
        VStack {
            // Header text
            Text("Select Lexia")
                .font(.largeTitle)
                .padding()

            
            // Vertical list of HStack items
            HStack {
                Image(systemName: "arrow.down")
                                .imageScale(.small)
                                .foregroundColor(.accentColor)
                Text("Tap and hold the globe")
                Image(systemName: "globe")
                                .imageScale(.small)
                                .foregroundColor(.accentColor)
                Text(" key below, and select Lexia")
            }

            TextField("Enter text", text: $inputText)
                .padding()
                .frame(width: 0.0, height: 0.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isInputFocused)
            Button("Next", action: {
                print("Push playground view")
            })
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
        }
        .onAppear {
           isInputFocused = true
       }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
