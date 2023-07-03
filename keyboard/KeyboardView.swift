//
//  KeyboardView.swift
//  keyboard
//
//  Created by ibbi on 5/15/23.
//

import SwiftUI
import KeyboardKit

struct KeyboardView: View {
    unowned var controller: KeyboardInputViewController
    @EnvironmentObject
    private var keyboardContext: KeyboardContext
    @AppStorage("recording", store: UserDefaults(suiteName: "group.lexia")) var isRecording: Bool = false
    @State private var rewrittenText: String = ""
    @State private var prewrittenText: String = ""
    @State private var prevContext: String? = ""
    


    var body: some View {
        if isRecording {
            StopRecording()
        } else {
            VStack(spacing: 0) {
                if controller.hostBundleId != "ibbi.dyslexia" {
                    HStack {
                        TranscribeButton(controller: controller)
                        Spacer()
                        RewriteButton(controller: controller, rewrittenText: $rewrittenText, prewrittenText: $prewrittenText, prevContext: $prevContext)
                        UndoButton(controller: controller, rewrittenText: $rewrittenText, prewrittenText: $prewrittenText, prevContext: $prevContext)
                    }
                    .padding(.vertical, 6)
                    
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
