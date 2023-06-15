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
    @Published var transcription: String?
    private var webSocketManager = API.WebSocketManager()

    func startRecording() {
        webSocketManager.connect { [weak self] success in
            if success {
                print("WebSocket connected successfully.")
                self?.startAudioRecording()
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
    
    
}


