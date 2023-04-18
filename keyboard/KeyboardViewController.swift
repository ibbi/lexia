//
//  KeyboardViewController.swift
//  LexiaKeyboard
//
//  Created by ibbi on 3/26/23.
//

import KeyboardKit
import SwiftUI

class KeyboardViewController: KeyboardInputViewController {

    override func viewDidLoad() {

        keyboardContext.setLocale(.english)
        keyboardAppearance = KeyboardAppearance(
            keyboardContext: keyboardContext)
        keyboardActionHandler = KeyboardActionHandler(
            inputViewController: self)
        keyboardLayoutProvider = KeyboardLayoutProvider(
            keyboardContext: keyboardContext,
            inputSetProvider: inputSetProvider)
        keyboardContext.keyboardDictationReplacement = .keyboardType(.emojis)


        /// 💡 Call super to perform the base initialization.
        super.viewDidLoad()
    }

    /**
     This function is called whenever the keyboard should be
     created or updated. Here, we setup a system keyboard as
     the main keyboard view.
     */
    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()

        /// 💡 Make the demo use a ``SystemKeyboard``.
        ///
        /// This is actually not needed. The controller will
        /// by default setup a `SystemKeyboard`, so you only
        /// have to override this function to setup a custom
        /// view, which we do in `KeyboardCustom`.
        setup { SystemKeyboard(controller: $0) }
    }
}
