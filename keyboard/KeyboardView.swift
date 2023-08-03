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
    @State private var rewrittenText: String = ""
    @State private var prewrittenText: String = ""
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

    
    


    var body: some View {
        let isGmail = controller.hostBundleId == "com.google.Gmail"
        
// TODO: Clean up this conditional mess
        VStack(spacing: 0) {
            if isInEditMode && !isRecording {
                HStack {
                    TopBarButton(buttonType: .discard, action:{
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
                    .onAppear{
                        isInputFocused = true
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
                    ZapButton(controller: controller, rewrittenText: $rewrittenText, prewrittenText: $prewrittenText, prevContext: $prevContext, forceUpdateButtons: forceUpdateButtons,  keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: isInEditMode, editText: $editText)
                    EditButton(controller: controller, rewrittenText: $rewrittenText, prewrittenText: $prewrittenText, prevContext: $prevContext, forceUpdateButtons: forceUpdateButtons, keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: isInEditMode, editText: $editText)
                    if isInEditMode {
                        Spacer()
                        UndoButton(controller: controller, rewrittenText: $rewrittenText, prewrittenText: $prewrittenText, prevContext: $prevContext)
                        TopBarButton(buttonType: .redo, action:{}, isLoading: .constant(false), isInBadContext: false)
                    } else {
                        Divider()
                        EditModeButton(controller: controller, rewrittenText: $rewrittenText, prewrittenText: $prewrittenText, prevContext: $prevContext, keyboardStatus: $keyboardStatus, isGmail: isGmail, isInEditMode: $isInEditMode, editText: $editText)
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

