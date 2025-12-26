//
//  AudioPlayer.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import Foundation
import AVFoundation

@Observable
class AudioPlayer: NSObject {
    var isPlaying = false
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    override init() {
        super.init()
    }
    
    func loadAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            duration = audioPlayer?.duration ?? 0
        } catch {
            print("Failed to load audio: \(error)")
        }
    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = self.audioPlayer?.currentTime ?? 0
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
        currentTime = 0
        timer?.invalidate()
        timer = nil
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentTime = 0
        timer?.invalidate()
        timer = nil
    }
}
