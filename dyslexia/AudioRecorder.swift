//
//  AudioRecorder.swift
//  dyslexia
//
//  Created by ibbi on 6/13/23.
//

import Foundation
import AVFoundation

class AudioRecorder: ObservableObject {
    private var audioRecorder: AVAudioRecorder!
    private var shortAudioData = Data()
    @Published var transcription: String?
    private var webSocketManager = API.WebSocketManager()
    private var shortRecordingTimer: Timer?

    func startRecording() {
        webSocketManager.connect { [weak self] success in
            if success {
                print("WebSocket connected successfully.")
                self?.startAudioRecording()
                self?.startRecordingTimer()
            } else {
                print("WebSocket connection failed.")
            }
        }
    }

    private func startAudioRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .default)
        try? audioSession.setActive(true)

        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioURL = documentPath.appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        try? audioRecorder = AVAudioRecorder(url: audioURL, settings: settings)
        audioRecorder.record()
    }


    func stopRecording() {
        audioRecorder.stop()
        stopRecordingTimer()
        webSocketManager.disconnect { success in
            if success {
                print("WebSocket disconnected successfully.")
            } else {
                print("WebSocket disconnection failed.")
            }
        }
    }

    func getAudioURL() -> URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentPath.appendingPathComponent("recording.m4a")
    }

    func transcribeAudio(completion: @escaping (Result<[String: Any], BackendAPIError>) -> Void) {
        let audioURL = getAudioURL()
        API.sendAudioForTranscription(audioURL: audioURL, completion: completion)
    }

    private func saveShortAudioData() {
        guard let audioRecorder = audioRecorder else { return }
        let audioData = audioRecorder.audioData
        let audioLength = audioData.count

        if audioLength >= 2 * 12000 {
            shortAudioData = audioData[(audioLength - 2 * 12000)...]
            webSocketManager.sendAudioData(shortAudioData)
            
            // Print the last few bytes of shortAudioData
            let lastBytes = shortAudioData.suffix(10)
            print("Last bytes of shortAudioData: \(lastBytes.map { String(format: "%02x", $0) }.joined())")
        } else {
            shortAudioData = audioData
        }
    }

    private func startRecordingTimer() {
        shortRecordingTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            self?.saveShortAudioData()
        }
    }

    private func stopRecordingTimer() {
        shortRecordingTimer?.invalidate()
        shortRecordingTimer = nil
    }
}

extension AVAudioRecorder {
    var audioData: Data {
        let audioURL = url
        return try! Data(contentsOf: audioURL)
    }
}
