//
//  IntroPage.swift
//  dyslexia
//
//  Created by ibbi on 7/6/23.
//

import SwiftUI

struct IntroPage: View {
    let playgrounds = ["whisper", "speak_edit", "quick_edit", "undo"]

    var body: some View {
        NavigationView {
            List(playgrounds, id: \.self) { playground in
                NavigationLink {
//                    Playground(playground: playground)
                } label: {
                    HStack {
                        switch playground{
                        case "whisper":
                            VStack(alignment: .leading) {
                                Button(action: {
                                }) {
                                    Text("Speak")
                                }
                                .buttonStyle(.bordered)
                                .tint(Color.pastelBlue)
                                Text("Speech to text in any language")
                            }
                        case "speak_edit":
                            VStack(alignment: .leading) {
                                Button(action: {
                                }) {
                                    Text("Edit")
                                }
                                .buttonStyle(.bordered)
                                .tint(Color.pastelGreen)
                                Text("Text edits using voice commands")
                            }
                        case "quick_edit":
                            VStack(alignment: .leading) {
                                Button(action: {
                                }) {
                                    Text("Enhance")
                                }
                                .buttonStyle(.bordered)
                                .tint(Color.pastelYellow)
                                Text("One tap edits, with saved presets")
                            }
                        default:
                            VStack(alignment: .leading) {
                                Button(action: {
                                }) {
                                    Text("Undo")
                                }
                                .buttonStyle(.bordered)
                                .tint(Color.pastelRed)
                                Text("Undo the last change")
                            }
                        }
                        Spacer()
                    }
                }
            }
            .padding(.vertical)
            .navigationTitle("Learn Lexboard")
        }
    }
}


struct IntroPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroPage()
    }
}
