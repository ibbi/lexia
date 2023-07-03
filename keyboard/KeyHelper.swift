//
//  KeyHelper.swift
//  keyboard
//
//  Created by ibbi on 7/3/23.
//

import Foundation
import KeyboardKit


class KeyHelper{
    
    static func getFiveSurroundingChars(controller: KeyboardInputViewController) -> String {
        let charsBeforeCursor = controller.textDocumentProxy.documentContextBeforeInput ?? ""
        let charsAfterCursor = controller.textDocumentProxy.documentContextAfterInput ?? ""
        
        let lastFiveCharsBeforeCursor = String(charsBeforeCursor.suffix(5))
        let firstFiveCharsAfterCursor = String(charsAfterCursor.prefix(5))
        
        return lastFiveCharsBeforeCursor + firstFiveCharsAfterCursor
    }
}

