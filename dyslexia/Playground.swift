//
//  Playground.swift
//  dyslexia
//
//  Created by ibbi on 7/15/23.
//

import KeyboardKit
import SwiftUI

struct Playground: View {
    let isKeyboardActive: Bool
    @State private var isFocused: Bool = false
    @AppStorage("finished_tour", store: UserDefaults(suiteName: "group.lexia")) var finishedTour: Bool = false
    @State private var inputText: String = ""
    @State private var generatorLoading: Bool = false
    
    func generateText() {
        generatorLoading = true
        API.generateText() { result in
            DispatchQueue.main.async {
                generatorLoading = false
                switch result {
                case .success(let generated):
                    inputText = generated
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Playground")
                    .font(.title)
                
                Spacer()
                
                Button(action: {
                    generateText()
                }) {
                    HStack {
                        if (generatorLoading) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(alignment: .center)
                                .padding(.trailing)
                        }
                        Text(generatorLoading ? "Generating" : "Generate text")
                        
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(generatorLoading)
            }
            Divider()
            TextEditor(text: $inputText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}


struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground(isKeyboardActive: true)
    }
}
