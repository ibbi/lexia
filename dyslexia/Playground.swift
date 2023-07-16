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
    @FocusState private var inFocus: Bool
    @State var currentStep: Int = 0
    let sharedDefaults = UserDefaults(suiteName: "group.lexia")
    
    struct TutorialStep {
        let id: Coachy
        let onNext: () -> Void
    }
    func getTutorialSteps() -> [TutorialStep] {
        [
            TutorialStep(id: .dictate, onNext: {
                if inputText.isEmpty {
                    inputText = "I hate the smell of butter!"
                }
                withAnimation {self.currentStep += 1}
            }),
            TutorialStep(id: .edit, onNext: { withAnimation {self.currentStep += 1} }),
            TutorialStep(id: .zapSelect, onNext: {
                withAnimation {self.currentStep += 1}
                sharedDefaults?.set(ZapOptions.rasta.id, forKey: "zap_mode_id")
            }),
            TutorialStep(id: .zap, onNext: { withAnimation {self.currentStep += 1} }),
            TutorialStep(id: .undo, onNext: {
                self.currentStep = 0
                sharedDefaults?.set(true, forKey: "finished_tour")
            })
        ]
    }
    
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
        let tutorialSteps = getTutorialSteps()

        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Playground")
                        .font(.title)
                    Spacer()
                    Button(action: {
                        sharedDefaults?.set(false, forKey: "finished_tour")
                    }) {
                        Text("Run tutorial")
                    }
                    .buttonStyle(.bordered)
                    .disabled(generatorLoading || !finishedTour || !isKeyboardActive)
                    
                }
                Divider()
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
                .disabled(generatorLoading || !finishedTour || !isKeyboardActive)
                .padding(.top)
                TextEditor(text: $inputText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(.foreground.opacity(0.1))
                    .focused($inFocus)
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    inFocus = true
                }
            }
            if !isKeyboardActive {
                CoachMark(coachID: Coachy.selectLexy, onNext: nil, onSkip: nil )
            }
            else if !finishedTour {
                CoachMark(coachID: tutorialSteps[currentStep].id, onNext: tutorialSteps[currentStep].onNext, onSkip: {
                    sharedDefaults?.set(true, forKey: "finished_tour")
                    currentStep = 0
                } )
            }
        }
    }
}

