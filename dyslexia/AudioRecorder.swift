//
//  Audio.swift
//  dyslexia
//
//  Created by ibbi on 5/31/23.
//

import AVFoundation

class AudioRecorder: ObservableObject {
    private let audioEngine = AVAudioEngine()
    private var audioConverter: AVAudioConverter?
    private let recordingFormat: AVAudioFormat
    private let sampleRate: Double = 16000
    private let webSocketManager: WebSocketManager

    init(webSocketManager: WebSocketManager) {
        self.webSocketManager = webSocketManager
        recordingFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: sampleRate, channels: 1, interleaved: true)!
    }

    func startRecording() {
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        audioConverter = AVAudioConverter(from: inputFormat, to: recordingFormat)

        inputNode.installTap(onBus: 0, bufferSize: 4096, format: inputFormat) { [weak self] (buffer, time) in
            self?.processAudioBuffer(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }

    private func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let audioConverter = audioConverter else { return }
        
        let inputFormat = buffer.format
        let capacity = UInt32(Float(buffer.frameCapacity) / Float(inputFormat.sampleRate / recordingFormat.sampleRate))
        let pcmBuffer = AVAudioPCMBuffer(pcmFormat: recordingFormat, frameCapacity: capacity)!
        var error: NSError? = nil
        
        let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
            outStatus.pointee = AVAudioConverterInputStatus.haveData
            return buffer
        }
        
        audioConverter.convert(to: pcmBuffer, error: &error, withInputFrom: inputBlock)
        
        if let error = error {
            print("Error converting audio buffer: \(error.localizedDescription)")
        } else {
            // The audio buffer is now converted to the desired format.
            // You can now process the pcmBuffer for further use.
            
            // Print input and output audio properties
            print("Input format: \(inputFormat)")
            print("Input sample rate: \(inputFormat.sampleRate)")
            print("Output format: \(recordingFormat)")
            print("Output sample rate: \(recordingFormat.sampleRate)")
            
            // Convert AVAudioPCMBuffer to Data
            let audioData = pcmBuffer.toData()
            
            // Encode the PCM binary chunk as a base64 string
            let base64String = audioData.base64EncodedString()
            
            // Now you can use the base64String to send it over the WebSocket
            webSocketManager.sendMessage(base64String)
        }
    }
}

// Add this extension to convert AVAudioPCMBuffer to Data
extension AVAudioPCMBuffer {
    func toData() -> Data {
        let channelCount = 1
        let channels = UnsafeBufferPointer(start: int16ChannelData, count: channelCount)
        let ch0Data = Data(bytes: channels[0], count: Int(frameLength) * MemoryLayout<Int16>.size)
        return ch0Data
    }
}
