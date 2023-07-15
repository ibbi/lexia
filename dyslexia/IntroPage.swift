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
                        Playground1(isKeyboardActive: isKeyboardActive)
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            switch playground {
                            case "speak":
                                TopBarButton(buttonType: .speak, action: {}, isLoading: .constant(false), onlyVisual: true, isInBadContext: false)
                                Text("Speech to text in any language")
                            case "edit":
                                TopBarButton(buttonType: .edit, action: {}, isLoading: .constant(false), onlyVisual: true, isInBadContext: false)
                                    Text("Text edits using voice commands")
                            case "enhance":
                                TopBarButton(buttonType: .enhance, action: {}, isLoading: .constant(false), onlyVisual: true, isInBadContext: false)
                                    Text("One tap edits, with saved presets")
                            default:
                                    HStack {
                                        TopBarButton(buttonType: .speak, action: nil, isLoading: .constant(false), onlyVisual: true, isInBadContext: false)
                                        TopBarButton(buttonType: .edit, action: nil, isLoading: .constant(false), onlyVisual: true, isInBadContext: false)
                                        TopBarButton(buttonType: .enhance, action: nil, isLoading: .constant(false), onlyVisual: true, isInBadContext: false)
                                        TopBarButton(buttonType: .undo, action: nil, isLoading: .constant(false), onlyVisual: true, isInBadContext: false)
                                    }
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
