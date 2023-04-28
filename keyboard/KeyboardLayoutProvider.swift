//
//  KeyboardLayoutProvider.swift
//  LexiaKeyboard
//
//  Created by ibbi on 4/15/23.
//

import KeyboardKit

class KeyboardLayoutProvider: StandardKeyboardLayoutProvider {
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)
        layout.tryInsertDictation()
        return layout
    }
}

private extension KeyboardLayout {

    var bottomRowIndex: Int {
        itemRows.count - 1
    }

    var hasRows: Bool {
        itemRows.count > 0
    }

    var newDictTemplate: KeyboardLayoutItem? {
        itemRows[bottomRowIndex].first { $0.action.isSystemAction }
    }

    func tryInsertDictation() {
        guard let template = newDictTemplate else { return }
        let switcher = KeyboardLayoutItem(action: .custom(named: "lexia"), size: template.size, insets: template.insets)
        itemRows.insert(switcher, after: .space, atRow: bottomRowIndex)
    }
}

