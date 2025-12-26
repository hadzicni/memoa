//
//  AudioRecorder.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import Foundation
import AVFoundation

@Observable
class AudioRecorder: NSObject {
    var isRecording = false
    var recordingTime: TimeInterval = 0
    var audioData: Data?

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var recordingURL: URL?

    override init() {
        super.init()
    }

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            recordingURL = documentsPath.appendingPathComponent("recording-\(UUID().uuidString).m4a")

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            guard let url = recordingURL else { return }
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()

            isRecording = true
            recordingTime = 0

            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.recordingTime += 0.1
            }
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        timer?.invalidate()
        timer = nil
        isRecording = false

        // Load the recorded audio data
        if let url = recordingURL,
           let data = try? Data(contentsOf: url) {
            audioData = data
        }
    }

    func clearRecording() {
        audioData = nil
        recordingTime = 0

        // Delete the file
        if let url = recordingURL {
            try? FileManager.default.removeItem(at: url)
        }
    }
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording failed")
        }
    }
}
