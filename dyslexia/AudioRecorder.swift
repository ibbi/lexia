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
    private var recordingFormat: AVAudioFormat!
//    private let sampleRate: Double = 16000
    private let webSocketManager: WebSocketManager
    private var chunkCounter = 0


    init(webSocketManager: WebSocketManager) {
        self.webSocketManager = webSocketManager
//        recordingFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: inputSampleRate, channels: 1, interleaved: true)!
    }

    func startRecording() {
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        let inputSampleRate = inputFormat.sampleRate
        recordingFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: inputSampleRate, channels: 1, interleaved: true)!
        audioConverter = AVAudioConverter(from: inputFormat, to: recordingFormat)

        let chunkDuration: TimeInterval = 0.3 // 300 ms
        let bufferSize = AVAudioFrameCount(chunkDuration * inputFormat.sampleRate)

        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: inputFormat) { [weak self] (buffer, time) in
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
    
    func createWAVHeader(dataSize: Int, sampleRate: Int) -> Data {
        let headerSize = 44
        let totalSize = dataSize + headerSize
        let byteRate = sampleRate * 2
        let blockAlign: UInt16 = 2

        var header = Data()
        header.reserveCapacity(headerSize)

        header.append(contentsOf: "RIFF".utf8) // ChunkID
        header.append(contentsOf: UInt32(totalSize).littleEndian.data) // ChunkSize
        header.append(contentsOf: "WAVE".utf8) // Format
        header.append(contentsOf: "fmt ".utf8) // Subchunk1ID
        header.append(contentsOf: UInt32(16).littleEndian.data) // Subchunk1Size (16 for PCM)
        header.append(contentsOf: UInt16(1).littleEndian.data) // AudioFormat (1 for PCM)
        header.append(contentsOf: UInt16(1).littleEndian.data) // NumChannels (1 for mono)
        header.append(contentsOf: UInt32(sampleRate).littleEndian.data) // SampleRate
        header.append(contentsOf: UInt32(byteRate).littleEndian.data) // ByteRate
        header.append(contentsOf: blockAlign.littleEndian.data) // BlockAlign
        header.append(contentsOf: UInt16(16).littleEndian.data) // BitsPerSample
        header.append(contentsOf: "data".utf8) // Subchunk2ID
        header.append(contentsOf: UInt32(dataSize).littleEndian.data) // Subchunk2Size

        return header
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
            let wavHeader = createWAVHeader(dataSize: audioData.count, sampleRate: Int(recordingFormat.sampleRate))
            var wavData = wavHeader
                wavData.append(audioData)
            let base64String = wavData.base64EncodedString()


            
            // Encode the PCM binary chunk as a base64 string
//            let base64String = audioData.base64EncodedString()
            chunkCounter += 1
            if chunkCounter < 2 {
                print("\(chunkCounter)")
                print("Base64 chunk: \(base64String)")
            }

            // Now you can use the base64String to send it over the WebSocket
            if webSocketManager.isConnected {
                webSocketManager.sendMessage(base64String)
            } else {
                print("WebSocket isn't connected. Skipping sending audio data.")
            }
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

extension FixedWidthInteger {
    var data: Data {
        var source = self
        return Data(bytes: &source, count: MemoryLayout<Self>.size)
    }
}
