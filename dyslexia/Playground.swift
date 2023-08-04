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
    @AppStorage("zap_mode_id", store: UserDefaults(suiteName: "group.lexia")) var zapModeID: String?
    @State private var oldZapModeID: String?
    @State private var inputText: String = ""
    @State private var oldInputText: String = ""
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
                if inputText.isEmpty || inputText.count < 4 {
                    inputText = "I hate the smell of butter!"
                } else {
                    withAnimation {currentStep += 1}
                }
            }),
            TutorialStep(id: .zapSelect, onNext: {
                if zapModeID == ZapOptions.rasta.id {
                    withAnimation {currentStep += 1}
                } else {
                    sharedDefaults?.set(ZapOptions.rasta.id, forKey: "zap_mode_id")
                }
            }),
            TutorialStep(id: .zap, onNext: { withAnimation {currentStep += 1} }),
            TutorialStep(id: .edit, onNext: { withAnimation {currentStep += 1} }),
            TutorialStep(id: .editMode, onNext: { withAnimation {currentStep += 1} }),
            TutorialStep(id: .confirm, onNext: {
                currentStep = 0
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
                CoachMark(coachID: Coachy.selectLexi, onNext: nil, onPrev: nil, onSkip: nil )
            }
            else if !finishedTour {
                CoachMark(coachID: tutorialSteps[currentStep].id, onNext: tutorialSteps[currentStep].onNext, onPrev: tutorialSteps[currentStep].id == .dictate ? nil : { withAnimation {currentStep = currentStep - 1} },  onSkip: {
                    sharedDefaults?.set(true, forKey: "finished_tour")
                    currentStep = 0
                } )
            }
        }
        .onChange(of: inputText) { newValue in
            if !finishedTour {
                if newValue != oldInputText {
                    switch tutorialSteps[currentStep].id {
                    case .dictate:
                        // TODO: Maybe look at recording state instead? Fine for now cus can't edit text
                        if (newValue.count - oldInputText.count > 1) {
                            withAnimation {currentStep += 1}
                        }
                    case .edit, .zap:
                        if (!newValue.contains(oldInputText) && !oldInputText.contains(newValue)) {
                            withAnimation {currentStep += 1}
                        }
//                    case .undo:
//                        if (oldInputText == newValue && !newValue.contains(oldInputText) && !oldInputText.contains(newValue)) {
//                            currentStep = 0
//                            sharedDefaults?.set(true, forKey: "finished_tour")
//                        }
                    default:
                        print("inputText changed")
                    }
                    oldInputText = newValue
                }
                
            }
        }
        .onChange(of: zapModeID) { newValue in
            if !finishedTour && tutorialSteps[currentStep].id == .zapSelect {
                if newValue == ZapOptions.rasta.id {
                    withAnimation {currentStep += 1}
                    oldZapModeID = newValue
                }
            }
        }
    }
}

