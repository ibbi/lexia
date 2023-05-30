//
//  Dictation.swift
//  dyslexia
//
//  Created by ibbi on 5/19/23.
//

import SwiftUI
import AVFoundation

@objc private protocol PrivateSelectors: NSObjectProtocol {
    var destinations: [NSNumber] { get }
    func sendResponseForDestination(_ destination: NSNumber)
}

struct Dictation: View {
    @State private var audioRecorder: AVAudioRecorder!
    @State private var webSocket = AssemblySocket()
    
    var body: some View {
        Text("Recording...")
            .onAppear {
                startRecording()
                webSocket.connect()
//                jumpBackToPreviousApp()
            }
            .onDisappear {
                webSocket.disconnect()
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
    
    func jumpBackToPreviousApp() -> Bool {
        guard
            let sysNavIvar = class_getInstanceVariable(UIApplication.self, "_systemNavigationAction"),
            let action = object_getIvar(UIApplication.shared, sysNavIvar) as? NSObject,
            let destinations = action.perform(#selector(getter: PrivateSelectors.destinations)).takeUnretainedValue() as? [NSNumber],
            let firstDestination = destinations.first
        else {
            return false
        }
        action.perform(#selector(PrivateSelectors.sendResponseForDestination), with: firstDestination)
        return true
    }
}

struct Dictation_Previews: PreviewProvider {
    static var previews: some View {
        Dictation()
    }
}
