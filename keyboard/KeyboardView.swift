//
//  KeyboardView.swift
//  keyboard
//
//  Created by ibbi on 5/15/23.
//

import SwiftUI
import KeyboardKit

enum KeyboardStatus {
    case available
    case reading
    case rewriting
}

struct KeyboardView: View {
    unowned var controller: KeyboardInputViewController
    @EnvironmentObject
    private var keyboardContext: KeyboardContext
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false
    @State private var prevContext: String? = ""
    @State private var keyboardStatus: KeyboardStatus = .available
    @State private var isInEditMode: Bool = false
    @FocusState private var isInputFocused: Bool
    // Hack to get inserttext to update views
    @State var forceUpdateButtons: Bool = false
    @State var editText: String = ""
    @FocusState private var isEditInputFocused: Bool
    @State var keyboardSize: CGSize = .zero
    @State var buttonRowSize: CGSize = .zero
    @State var undoRedoStack: [String] = []
    @State var undoRedoIdx: Int = 0

    func resetEditSpace() {
        undoRedoStack = []
        undoRedoIdx = 0
        editText = ""
    }

    var body: some View {
        let isGmail = controller.hostBundleId == "com.google.Gmail"
        
// TODO: Clean up this conditional mess
        VStack(spacing: 0) {
            if isInEditMode && !isRecording {
                HStack {
                    TopBarButton(buttonType: .discard, action:{
                        resetEditSpace()
                        withAnimation {
                            isInEditMode = false
                        }
                    }, isLoading: .constant(false), isInBadContext: false)
                    Text(keyboardStatus  == .reading ? "Reading..." : keyboardStatus == .rewriting ? "Writing..." : "")
                    Spacer()
                    TopBarButton(buttonType: .confirm, action:{
                        withAnimation {
                            isInEditMode = false
                        }
                    }, isLoading: .constant(false), isInBadContext: false)
                }
                .padding(6)
                .padding(.top, 6)
            }
            if isInEditMode {
                KeyboardTextView(text: $editText, controller: controller)
                    .focused($isInputFocused)
                    .padding(6)
                    .frame(height: isRecording ? buttonRowSize.height : keyboardSize.height - buttonRowSize.height)
                    .onAppear {
                        isInputFocused = true
                    }
                    .onDisappear {
                        resetEditSpace()
                        isInEditMode = false
                    }
                if isRecording {
                    StopRecording(height: keyboardSize.height)
                }
            }
            if !isRecording {
                HStack {
                    if !isInEditMode {
                        TranscribeButton(controller: controller, forceUpdateButtons: $forceUpdateButtons)
                        Text(keyboardStatus  == .reading ? "Reading..." : keyboardStatus == .rewriting ? "Writing..." : "")
                        Spacer()
                    }
                    ZapButton(controller: controller, prevContext: $prevContext, forceUpdateButtons: forceUpdateButtons,  keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: isInEditMode, editText: $editText)
                    EditButton(controller: controller, prevContext: $prevContext, forceUpdateButtons: forceUpdateButtons, keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: isInEditMode, editText: $editText)
                    if isInEditMode {
                        Spacer()
                        UndoRedoButtons(editText: $editText, undoRedoStack: $undoRedoStack, undoRedoIdx: $undoRedoIdx)
                    } else {
                        Divider()
                        EditModeButton(controller: controller, prevContext: $prevContext, keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: $isInEditMode, editText: $editText, undoRedoStack: $undoRedoStack)
                    }
                }
                .padding(6)
                .padding(.top, 6)
                .fixedSize(horizontal: false, vertical: true)
                .saveSize(in: $buttonRowSize)
                if (!isInEditMode) {
                    SystemKeyboard(
                        controller: controller,
                        autocompleteToolbar: .none
                    )
                    .saveSize(in: $keyboardSize)
                }
            }
            else if !isInEditMode {
                StopRecording(height: keyboardSize.height + buttonRowSize.height)
            }
        }
    }
}

