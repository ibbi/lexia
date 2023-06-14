//
//  TranscribeButton.swift
//  dyslexia
//
//  Created by ibbi on 5/15/23.
//

import SwiftUI
import KeyboardKit
import URLProxy

struct TranscribeButton: View {
    let controller: KeyboardInputViewController

    var body: some View {
        Button("Talk", action: {
            if controller.hostBundleId != "ibbi.dyslexia" {
                let urlHandler = URLHandler()
                urlHandler.openURL("dyslexia://dictation")
            }
            else {
                // TODO: Handle dictation on this page
            }

        })
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.pastelBlue)
    }
}

//struct TranscribeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscribeButton()
//    }
//}
