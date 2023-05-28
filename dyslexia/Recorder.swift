//
//  Recorder.swift
//  dyslexia
//
//  Created by ibbi on 5/26/23.
//

import Foundation
import AVFoundation

class Recorder {
  enum RecordingState {
    case recording, paused, stopped
  }
  
  private var engine: AVAudioEngine!
  private var mixerNode: AVAudioMixerNode!
  private var state: RecordingState = .stopped
    
    fileprivate func setupSession() {
      let session = AVAudioSession.sharedInstance()
      try? session.setCategory(.record)
      try? session.setActive(true, options: .notifyOthersOnDeactivation)
    }
    fileprivate func setupEngine() {
      engine = AVAudioEngine()
      mixerNode = AVAudioMixerNode()

      // Set volume to 0 to avoid audio feedback while recording.
      mixerNode.volume = 0

      engine.attach(mixerNode)

      makeConnections()
      
      // Prepare the engine in advance, in order for the system to allocate the necessary resources.
      engine.prepare()
    }

    fileprivate func makeConnections() {
      let inputNode = engine.inputNode
      let inputFormat = inputNode.outputFormat(forBus: 0)
      engine.connect(inputNode, to: mixerNode, format: inputFormat)

      let mainMixerNode = engine.mainMixerNode
      let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
      engine.connect(mixerNode, to: mainMixerNode, format: mixerFormat)
    }
    
    func startRecording() throws {
      let tapNode: AVAudioNode = mixerNode
      let format = tapNode.outputFormat(forBus: 0)

      let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      
      // AVAudioFile uses the Core Audio Format (CAF) to write to disk.
      // So we're using the caf file extension.
      let file = try AVAudioFile(forWriting: documentURL.appendingPathComponent("recording.caf"), settings: format.settings)

      tapNode.installTap(onBus: 0, bufferSize: 4096, format: format, block: {
        (buffer, time) in
        try? file.write(from: buffer)
      })

      try engine.start()
      state = .recording
    }
  
    func resumeRecording() throws {
      try engine.start()
      state = .recording
    }

    func pauseRecording() {
      engine.pause()
      state = .paused
    }

    func stopRecording() {
      // Remove existing taps on nodes
      mixerNode.removeTap(onBus: 0)
      
      engine.stop()
      state = .stopped
    }
  init() {
    setupSession()
    setupEngine()
  }
}
