//
//  Dictation.swift
//  dyslexia
//
//  Created by ibbi on 5/19/23.
//

import SwiftUI
import AVFoundation

struct Dictation: View {
    @State private var audioRecorder: AVAudioRecorder!
    @StateObject private var webSocket = WebSocketManager()
    
    var body: some View {
        VStack {
            Button("Start socket") {
                webSocket.startConnection()
            }
            Spacer()
            Button("Stop socket"){
                webSocket.disconnect()
            }
            Spacer()
            if let message = webSocket.latestMessage {
                Text("Latest message: \(message)")
            }
        }
            .onAppear {
//                startRecording()
//                webSocket.startConnection()
//                jumpBackToPreviousApp()
            }
            .onDisappear {
//                webSocket.disconnect()
            }
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
        } catch {
            print("Could not start recording")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

struct Dictation_Previews: PreviewProvider {
    static var previews: some View {
        Dictation()
    }
}
