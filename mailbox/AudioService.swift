//
//  AudioService.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import Foundation
import AVFoundation
import Observation

@Observable
final class AudioService {
    var player: AVPlayer?
    var isPlaying: Bool = false
    var hasStarted: Bool = false
    var duration: CMTime?
    
    private var observer: Any?
    
    var time: CGFloat?

    func play(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        player?.play()
        
        duration = player?.currentItem?.asset.duration
        
        hasStarted = true
        isPlaying = true
    }

    func playPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        
        isPlaying.toggle()
    }
    
    func startTimeListener() {

        if let ob = self.observer {
            player?.removeTimeObserver(ob)
        }
        
        let interval = CMTime(value: 1, timescale: 2)
        
        self.observer = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
            self?.time = CGFloat(time.seconds)
        }
    }
}

