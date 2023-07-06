//
//  IntroPage.swift
//  dyslexia
//
//  Created by ibbi on 7/6/23.
//

import SwiftUI

struct IntroPage: View {
    let playgrounds = ["whisper", "speak_edit", "quick_edit"]

    var body: some View {
        NavigationView {
            List(playgrounds, id: \.self) { playground in
                NavigationLink {
//                    Playground(playground: playground)
                } label: {
                    HStack {
                        switch playground{
                        case "whisper":
                            Image("Micon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Write by speaking in any language")
                        case "speak_edit":
                            Button(action: {
                            }) {
                                Text("Edit")
                            }
                            .buttonStyle(.bordered)
                            Text("Tell Lexboard how you want text to change")
                        default:
                            Button(action: {
                            }) {
                                Text("Enhance")
                            }
                            .buttonStyle(.bordered)
                            Text("Quickly improve your text with one tap")
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Learn how to use Lexboard")
        }
    }
}


struct IntroPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroPage()
    }
}
