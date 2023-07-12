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
    
    static func truncateRepliesInGmail(str: String) -> String {
        let pattern = "On (Mon|Tue|Wed|Thu|Fri|Sat|Sun), (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \\d{1,2}, \\d{4} at \\d{1,2}:\\d{2} (?=.{0,100}<.*@.*\\..*> wrote:)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        if let match = regex?.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.utf16.count)) {
            let start = str.startIndex
            let end = str.index(start, offsetBy: match.range.location)
            return String(str[start..<end])
        }
        
        return str
    }
    
    static func containsGmailReplyPattern(str: String) -> Bool {
        let pattern = "^On (Mon|Tue|Wed|Thu|Fri|Sat|Sun), (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \\d{1,2}, \\d{4} at \\d{1,2}:\\d{2} (?=.{0,100}<.*@.*\\..*> wrote:)"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        return regex?.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.utf16.count)) != nil
    }
}

