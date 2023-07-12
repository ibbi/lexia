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
    
    // Hack to get inserttext to update views
    @State var forceUpdateButtons: Bool = false
    
    


    var body: some View {
        let isGmail = controller.hostBundleId == "com.google.Gmail"
        if isRecording {
            StopRecording()
        } else {
            VStack(spacing: 0) {
                if controller.hostBundleId != "ibbi.dyslexia" {
                    HStack {
                        TranscribeButton(controller: controller, forceUpdateButtons: $forceUpdateButtons)
                        VoiceRewriteButton(controller: controller, rewrittenText: $rewrittenText, prewrittenText: $prewrittenText, prevContext: $prevContext, forceUpdateButtons: forceUpdateButtons, keyboardStatus: $keyboardStatus, isGmail: isGmail)
                        RewriteButton(controller: controller, rewrittenText: $rewrittenText, prewrittenText: $prewrittenText, prevContext: $prevContext, forceUpdateButtons: forceUpdateButtons,  keyboardStatus: $keyboardStatus, isGmail: isGmail)
                        Text(keyboardStatus  == .reading ? "Reading..." : keyboardStatus == .rewriting ? "Writing..." : "")
                        Spacer()
                        UndoButton(controller: controller, rewrittenText: $rewrittenText, prewrittenText: $prewrittenText, prevContext: $prevContext)
                    }
                    .padding(6)
                    .padding(.top, 6)
                    
                }
                SystemKeyboard(
                    controller: controller,
                    autocompleteToolbar: .none
                )
            }
            
        }
    }
}

//struct KeyboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeyboardView()
//    }
//}
