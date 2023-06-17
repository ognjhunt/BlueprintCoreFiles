//
//  SpeechRecorder.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 3/17/23.
//

import UIKit
import Foundation
import AVFoundation

class SpeechRecorder: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
        private var onRecordingFinished: ((Data?) -> Void)?
    var audioSession: AVAudioSession!
    var audioFileURL: URL?
    
    override init() {
        super.init()
        audioSession = AVAudioSession.sharedInstance()
        setupAudioRecorder()
    }
    
    func setupAudioRecorder() {
        do {
            // Set up the audio session category, mode, and activation
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
            
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            audioFileURL = audioFilename
        } catch {
            // Handle error
            print("Failed to set up audio recorder: \(error)")
            
        }
    }
//        func startRecording(onFinished: @escaping (Data?) -> Void) {
//            onRecordingFinished = onFinished
//
//            let audioSession = AVAudioSession.sharedInstance()
//            try? audioSession.setCategory(.record, mode: .default)
//            try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//
//            let settings: [String: Any] = [
//                AVFormatIDKey: Int(kAudioFormatLinearPCM),
//                AVSampleRateKey: 16000,
//                AVNumberOfChannelsKey: 1,
//                AVLinearPCMBitDepthKey: 16,
//                AVLinearPCMIsFloatKey: false,
//                AVLinearPCMIsBigEndianKey: false,
//                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//            ]
//
//            let url = getDocumentsDirectory().appendingPathComponent("recording.wav")
//            try? FileManager.default.removeItem(at: url)
//
//            audioRecorder = try? AVAudioRecorder(url: url, settings: settings)
//            audioRecorder?.delegate = self
//            audioRecorder?.record()
//        }
        
    func startRecording() {
        audioRecorder?.record()
    }
    
        func stopRecording() {
            audioRecorder?.stop()
        }
        
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            let data = try? Data(contentsOf: recorder.url)
            onRecordingFinished?(data)
        }
        
        private func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
    }

