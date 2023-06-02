//
//  AudioPlayer.swift
//  dyslexia
//
//  Created by ibbi on 6/1/23.
//

import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?

    func play(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else {
            print("Error decoding base64 string")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
