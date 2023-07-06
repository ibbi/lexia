//
//  InAppTranscribeButton.swift
//  dyslexia
//
//  Created by ibbi on 7/1/23.
//

import URLProxy
import SwiftUI
import KeyboardKit

struct InAppTranscribeButton: View {
    @State var isTranscribing: Bool = false
    @Binding var inputText: String
    @Binding var selectedText: String
    @Binding var selectedTextRange: NSRange
    let sharedDefaults = UserDefaults(suiteName: "group.lexia")
    
    
    @StateObject private var audioRecorder = AudioRecorder()

    
    func tryTranscribe() {
        func sharedDirectoryURL() -> URL {
            let fileManager = FileManager.default
            return fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")!
        }
        
        func getAudioURL() -> URL {
            let sharedDataPath = sharedDirectoryURL()
            return sharedDataPath.appendingPathComponent("recording.m4a")
        }
        
        func transcribeAudio(completion: @escaping (Result<String, BackendAPIError>) -> Void) {
            let audioURL = getAudioURL()
            API.sendAudioForTranscription(audioURL: audioURL, completion: completion)
        }
        
        let audioURL = getAudioURL()
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: audioURL.path) {
            isTranscribing = true
            transcribeAudio { result in
                isTranscribing = false
                switch result {
                case .success(let text):
                    if !text.isEmpty {
                        let startIndex = inputText.index(inputText.startIndex, offsetBy: selectedTextRange.location)
                        let endIndex = inputText.index(startIndex, offsetBy: selectedTextRange.length)
                        
                        inputText.removeSubrange(startIndex..<endIndex)
                        inputText.insert(contentsOf: text, at: startIndex)
                        selectedText = ""
                        selectedTextRange = NSRange(location: selectedTextRange.location + text.count, length: 0)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
                do {
                    try fileManager.removeItem(at: audioURL)
                } catch {
                    print("Error deleting file: \(error)")
                }
            }
        }
    }
    
    var body: some View {
        HStack {
            Button(action: {
                audioRecorder.startRecording(shouldJumpBack: false, isEdit: false)
            }) {
                Image("Micon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            .onAppear {
                tryTranscribe()
            }
            if isTranscribing {
                Text("Transcribing...")
            }
        }
    }
}
//struct TranscribeButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscribeButton()
//    }
//}
