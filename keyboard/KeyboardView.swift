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
//    @State private var isRecording: Bool = false
    @AppStorage("is_in_edit_mode", store: UserDefaults(suiteName: "group.lexia")) var isInEditModeDefaults: Bool = false
    @State private var isInEditMode: Bool = false
    @State private var prevContext: String? = ""
    @State private var wasSelectedText: Bool = false
    @State private var keyboardStatus: KeyboardStatus = .available
    @FocusState private var isInputFocused: Bool
    // Hack to get inserttext to update views
    @State var forceUpdateButtons: Bool = false
    @State var editText: String = ""
    @State var initialText: String = ""
    @State var keyboardSize: CGSize = .zero
    @State var buttonRowSize: CGSize = .zero
    @State var undoRedoStack: [String] = []
    @State var undoRedoIdx: Int = 0

    func resetEditSpace() {
        undoRedoStack = []
        undoRedoIdx = 0
        editText = ""
        prevContext = ""
        wasSelectedText = false
        initialText = ""
        isInputFocused = false
    }

    var body: some View {
        let sharedDefaults = UserDefaults(suiteName: "group.lexia")
        let gmailBundleId = "com.google.Gmail"
        let bundleId = controller.hostBundleId
        let isGmail = bundleId == gmailBundleId
        
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
                    ConfirmEditButton(controller: controller, prevContext: prevContext, wasSelectedText: wasSelectedText, keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: $isInEditMode, editText: editText, initialText: initialText, resetEditSpace: resetEditSpace)
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
                    ZapButton(controller: controller, forceUpdateButtons: forceUpdateButtons,  keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: isInEditMode, editText: $editText)
                    Divider()
                    EditButton(controller: controller, forceUpdateButtons: forceUpdateButtons, keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: isInEditMode, editText: $editText)
                    if isInEditMode {
                        Spacer()
                        UndoRedoButtons(editText: $editText, undoRedoStack: $undoRedoStack, undoRedoIdx: $undoRedoIdx)
                    } else {
                        Divider()
                        EditModeButton(controller: controller, prevContext: $prevContext, wasSelectedText: $wasSelectedText,keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: $isInEditMode, editText: $editText, initialText: $initialText, undoRedoStack: $undoRedoStack)
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
        //TODO: Figure out better way to do this, ew
        .onChange(of: isInEditMode) { newValue in
            if (newValue != isInEditModeDefaults) {
                UserDefaults(suiteName: "group.lexia")?.set(newValue, forKey: "is_in_edit_mode")
            }
        }
        .onChange(of: isInEditModeDefaults) { newValue in
            if (isInEditMode != newValue) {
                if (newValue == false) {
                    withAnimation {
                        isInEditMode = newValue
                    }
                }
            }
        }
        .onAppear() {
            sharedDefaults?.set(bundleId, forKey: "last_app_bundle_id")
        }
//        .onChange(of: isRecordingDefaults) { newValue in
//            if (isRecording != newValue) {
//                withAnimation {
//                    isRecording = newValue
//                }
//            }
//        }
    }
}

