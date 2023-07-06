//
//  AudioRecorder.swift
//  dyslexia
//
//  Created by ibbi on 6/13/23.
//

import Foundation
import AVFoundation
import UIKit

class AudioRecorder: ObservableObject {
    private var audioRecorder: AVAudioRecorder!
    @Published var transcription: String?
    var recordingCheckTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    let sharedDefaults = UserDefaults(suiteName: "group.lexia")

    
    func sharedDirectoryURL() -> URL {
        let fileManager = FileManager.default
        return fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")!
    }

    func startRecording(shouldJumpBack: Bool, isEdit: Bool) {
        if (shouldJumpBack) {
            backgroundTask = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid
            }
            Helper.jumpBackToPreviousApp()
        }

        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)

            let sharedDataPath = sharedDirectoryURL()
            let audioURL = sharedDataPath.appendingPathComponent(isEdit ? "edit_recording.m4a" :"recording.m4a")

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            try audioRecorder = AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder.record()

            sharedDefaults?.set(true, forKey: "recording")

            recordingCheckTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                let isStoppingRecording = self.sharedDefaults?.bool(forKey: "stopping_recording") ?? false
                if isStoppingRecording {
                    self.audioRecorder.stop()
                    self.sharedDefaults?.set(false, forKey: "stopping_recording")
                    self.sharedDefaults?.set(false, forKey: "recording")
                    timer.invalidate()
                    UIApplication.shared.endBackgroundTask(self.backgroundTask)
                    self.backgroundTask = .invalid
                }
            }
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder.stop()
    }
}
