//
//  InAppVoiceRewriteButton.swift
//  dyslexia
//
//  Created by ibbi on 7/5/23.
//

import SwiftUI
import KeyboardKit
import Combine
import URLProxy

struct InAppVoiceRewriteButton: View {
    
    @Binding var inputText: String
    @Binding var prevInputText: String
    @Binding var selectedText: String
    @Binding var selectedTextRange: NSRange
    
    @State private var transformedText: String?
    @State private var isLoading: Bool = false
    
    @StateObject private var audioRecorder = AudioRecorder()

    func getAudioURL() -> URL {
        let fileManager = FileManager.default
        let sharedDataPath = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")!
        return sharedDataPath.appendingPathComponent("edit_recording.m4a")
    }

    
    func tryGetContext() {
        let audioURL = getAudioURL()
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: audioURL.path) {
            isLoading = true
            rewriteTextWithAudioInstructions(selectedText.isEmpty ? inputText : selectedText)
        }
    }


    func rewriteTextWithAudioInstructions(_ text: String) {
        let audioURL = getAudioURL()
        API.sendAudioAndText(audioURL: audioURL, contextText: text) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let transformed):
                    if !selectedText.isEmpty {
                        prevInputText = inputText
                        let nsString = inputText as NSString
                        inputText = nsString.replacingCharacters(in: selectedTextRange, with: transformed)
                        selectedText = ""
                        selectedTextRange = NSRange(location: selectedTextRange.location + transformed.count, length: 0)
                    } else {
                        prevInputText = inputText
                        inputText = transformed
                        selectedText = ""
                        selectedTextRange = NSRange(location: inputText.count, length: 0)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
                do {
                    let fileManager = FileManager.default
                    try fileManager.removeItem(at: audioURL)
                } catch {
                    print("Error deleting file: \(error)")
                }
            }
        }
    }
    
    var body: some View {
            TopBarButton(buttonType: ButtonType.edit, action: {
                    audioRecorder.startRecording(shouldJumpBack: false, isEdit: true)
                }, isLoading: $isLoading, onlyVisual: false, isInBadContext: inputText.isEmpty)
            .onAppear{
                tryGetContext()
            }
    }
}


//struct InAppVoiceRewriteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        InAppVoiceRewriteButton()
//    }
//}
