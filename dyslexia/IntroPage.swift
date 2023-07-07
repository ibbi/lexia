//
//  IntroPage.swift
//  dyslexia
//
//  Created by ibbi on 7/6/23.
//

import SwiftUI

struct IntroPage: View {
    let isKeyboardActive: Bool
    let playgrounds = ["speak", "edit", "enhance", "undo"]
    

    var body: some View {
        NavigationView {
            List(playgrounds, id: \.self) { playground in
                NavigationLink {
                    switch playground {
                    case "speak":
                        SpeakPlayground(isKeyboardActive: isKeyboardActive)
                    case "edit":
                        EditPlayground(isKeyboardActive: isKeyboardActive)
                    case "enhance":
                        EnhancePlayground(isKeyboardActive: isKeyboardActive)
                    default:
                        Playground(isKeyboardActive: isKeyboardActive)
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            switch playground {
                            case "speak":
                                    Image(systemName: "mic.fill")
                                    Text("Speech to text in any language")
                            case "edit":
                                    Button(action: {
                                    }) {
                                        Text("Edit")
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(Color.pastelGreen)
                                    Text("Text edits using voice commands")
                            case "enhance":
                                    Button(action: {
                                    }) {
                                        Text("Enhance")
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(Color.pastelYellow)
                                    Text("One tap edits, with saved presets")
                            default:
                                    HStack {
                                        Button(action: {
                                        }) {
                                            Text("Speak")
                                        }
                                        .buttonStyle(.bordered)
                                        .tint(Color.pastelBlue)
                                        Button(action: {
                                        }) {
                                            Text("Edit")
                                        }
                                        .buttonStyle(.bordered)
                                        .tint(Color.pastelGreen)
                                        Button(action: {
                                        }) {
                                            Text("Enhance")
                                                .lineLimit(1)
                                        }
                                        .buttonStyle(.bordered)
                                        .tint(Color.pastelYellow)
                                        Button(action: {
                                        }) {
                                            Text("Undo")
                                        }
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(Color.pastelRed)
                                    Text("Put it all together")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Playground")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct IntroPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroPage(isKeyboardActive: true)
    }
}
