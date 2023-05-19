//
//  Dictation.swift
//  dyslexia
//
//  Created by ibbi on 5/19/23.
//

import SwiftUI

// TODO: Activate microphone and immediately pop back to previous (host) where keyboard was used.
// Keep audio in shared context in app group, send to whisper, and return. Or use native.
struct Dictation: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Dictation_Previews: PreviewProvider {
    static var previews: some View {
        Dictation()
    }
}
