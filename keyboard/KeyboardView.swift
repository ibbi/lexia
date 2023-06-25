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

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TranscribeButton(controller: controller)
                RewriteButton(controller: controller)
                TranscribeShared(controller: controller)
            }
            SystemKeyboard(
                controller: controller,
                autocompleteToolbar: .none
            )
            .background(Color.pastelBlue)
        }
    }
}

//struct KeyboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeyboardView()
//    }
//}
