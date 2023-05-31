//
//  Audio.swift
//  dyslexia
//
//  Created by ibbi on 5/31/23.
//

import AVFoundation

class AudioCapture: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate, ObservableObject {
    private let session = AVCaptureSession()
    private let audioDataOutput = AVCaptureAudioDataOutput()
    private let audioDataOutputQueue = DispatchQueue(label: "AudioDataOutputQueue")
    
    override init() {
        super.init()
        
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
            print("Could not get audio device.")
            return
        }
        
        do {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if session.canAddInput(audioInput) {
                session.addInput(audioInput)
            } else {
                print("Could not add audio input to session.")
                return
            }
            
            if session.canAddOutput(audioDataOutput) {
                session.addOutput(audioDataOutput)
            } else {
                print("Could not add audio data output to session.")
                return
            }
            
            audioDataOutput.setSampleBufferDelegate(self, queue: audioDataOutputQueue)
        } catch {
            print("Error while setting up audio capture: \(error)")
        }
    }
    
    func start() {
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stop() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Handle audio sample buffer here
        print("Received audio sample buffer.")
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Handle dropped audio sample buffer here
        print("Dropped audio sample buffer.")
    }
}
