//
//  Dictation.swift
//  dyslexia
//
//  Created by ibbi on 5/19/23.
//

import SwiftUI
import AVFoundation

struct Dictation: View {

    @State private var isRecording = false
    @State private var audioEngine = AVAudioEngine()
    
    @StateObject private var webSocket = WebSocketManager()
    
    
    var body: some View {
        VStack {
            Group {
                Spacer()
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
                Spacer()
            }
            Group {
                Text(isRecording ? "Recording..." : "Not Recording")
                Spacer()
                Button(action: {
                    if isRecording {
                        self.stopRecording()
                    } else {
                        self.startRecording()
                    }
                    
                    isRecording.toggle()
                }) {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
    }
    
    func startRecording() {
        let bus = 0
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: bus)
        
        var streamDescription = AudioStreamBasicDescription()
        streamDescription.mFormatID = kAudioFormatLinearPCM // PCM audio
        streamDescription.mSampleRate = 16000.0 // Desired sample rate
        streamDescription.mChannelsPerFrame = 1 // Mono audio
        streamDescription.mBitsPerChannel = 16 // 16 bits per sample
        streamDescription.mBytesPerPacket = 2 // 2 bytes per packet (16 bits per channel * 1 channel)
        streamDescription.mFramesPerPacket = 1 // 1 frame per packet (PCM audio)
        streamDescription.mBytesPerFrame = 2 // 2 bytes per frame (16 bits per channel * 1 channel)
        streamDescription.mReserved = 0
        
        let outputFormat = AVAudioFormat(streamDescription: &streamDescription)!
        
        guard let converter: AVAudioConverter = AVAudioConverter(from: inputFormat, to: outputFormat) else {
            print("Can't convert in to this format")
            return
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: inputFormat) { (buffer, time) in
            var newBufferAvailable = true
            
            let inputCallback: AVAudioConverterInputBlock = { inNumPackets, outStatus in
                if newBufferAvailable {
                    outStatus.pointee = .haveData
                    newBufferAvailable = false
                    return buffer
                } else {
                    outStatus.pointee = .noDataNow
                    return nil
                }
            }
            
            let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(outputFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate))!
            
            var error: NSError?
            let status = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputCallback)
            assert(status != .error)
            
            // Convert the audio data to Data and send it over the WebSocket:
            if let channelData = convertedBuffer.floatChannelData {
                let length = Int(convertedBuffer.frameCapacity * convertedBuffer.format.streamDescription.pointee.mBytesPerFrame)
                let data = Data(bytes: channelData, count: length)
                
                let base64Data = data.base64EncodedString()
                
                let audioMessage: [String: Any] = ["audio_data": base64Data]
                let jsonData = try! JSONSerialization.data(withJSONObject: audioMessage, options: [])
                let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
                
                self.webSocket.sendMessage(jsonString)
            }
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Can't start the engine: \(error)")
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
}

struct Dictation_Previews: PreviewProvider {
    static var previews: some View {
        Dictation()
    }
}
