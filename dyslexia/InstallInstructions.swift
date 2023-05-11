//
//  InstallInstructions.swift
//  dyslexia
//
//  Created by ibbi on 5/10/23.
//

import SwiftUI

struct InstallInstructions: View {
    @Binding var shouldShowInstallFlow: Bool
    @State private var isInstalled: Bool = Helper.isLexiaInstalled()
    @FocusState private var isInputFocused: Bool
    @State private var inputText: String = ""


    
    let installTodos: [(image: Image, text: String)] = [
        (Image("SettingsIcon"), "Go to settings"),
        (Image(systemName: "app.gift.fill"), "Lexia"),
        (Image("KeyboardIcon"), "Keyboards"),
        (Image("ToggleIcon"), "Enable Lexia"),
        (Image("ToggleIcon"), "Allow Full Access"),
        (Image(systemName: "return"), "Come back here to finish setup")
    ]
    
    let selectTodos: [(image: Image, text: String)] = [
        (Image(systemName: "globe"), "Tap and hold the globe icon below your keyboard"),
        (Image(systemName: "hand.point.up.left.fill"), "Select Lexia from the dropdown"),
    ]
    
    var body: some View {
        if isInstalled {
            VStack {

                Text("Select Lexia")
                    .font(.largeTitle)
                    .padding()

                List {
                    ForEach(0..<selectTodos.count, id: \.self) { index in
                        TodoItem(index: index, image: selectTodos[index].image, text: selectTodos[index].text)
                    }
                }
                TextField("Enter text", text: $inputText)
                    .padding()
                    .frame(width: 0.0, height: 0.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isInputFocused)
                Button("All done!", action: {
                    Helper.saveShouldShowInstallFlow(false)
                    shouldShowInstallFlow = false
                })
                .padding()
            }
            .onAppear {
               isInputFocused = true
           }
        } else {
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
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                isInstalled = Helper.isLexiaInstalled()
            }
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
//
//struct InstallInstructions_Previews: PreviewProvider {
//    static var previews: some View {
//        InstallInstructions(shouldShowInstallFlow: true)
//    }
//}
