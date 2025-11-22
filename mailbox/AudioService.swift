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
    var duration: CGFloat = 0
    
    private var observer: Any?
    
    var time: CGFloat?

    func play(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: playerItem)
        
        duration = CGFloat(player?.currentItem?.asset.duration.seconds ?? 1)
        print("SET DURATION: \(duration)")
        
        player?.play()
        startTimeListener()
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
            print("NEW TIME: \(time)")
        }
    }
    
    func sliderSeek(to time: CGFloat) {
        player?.pause()
        player?.seek(to: CMTime(seconds: Double(time), preferredTimescale: 600))
        player?.play()
    }
}

