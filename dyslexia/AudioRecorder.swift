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

    
    func sharedDirectoryURL() -> URL {
        let fileManager = FileManager.default
        return fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.lexia")!
    }

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .default)
        try? audioSession.setActive(true)

        let sharedDataPath = sharedDirectoryURL()
        let audioURL = sharedDataPath.appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        try? audioRecorder = AVAudioRecorder(url: audioURL, settings: settings)
        audioRecorder.record()
        
        let sharedDefaults = UserDefaults(suiteName: "group.lexia")
        sharedDefaults?.set(true, forKey: "recording")
        
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }

        recordingCheckTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            let isStoppingRecording = sharedDefaults?.bool(forKey: "stopping_recording") ?? false
            if isStoppingRecording {
                self.audioRecorder.stop()
                sharedDefaults?.set(false, forKey: "stopping_recording")
                sharedDefaults?.set(false, forKey: "recording")
                timer.invalidate()
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid
            }
        }
    }

    func stopRecording() {
        audioRecorder.stop()
    }

    func getAudioURL() -> URL {
        let sharedDataPath = sharedDirectoryURL()
        return sharedDataPath.appendingPathComponent("recording.m4a")
    }

    func transcribeAudio(completion: @escaping (Result<[String: Any], BackendAPIError>) -> Void) {
        let audioURL = getAudioURL()
        API.sendAudioForTranscription(audioURL: audioURL, completion: completion)
    }
}
