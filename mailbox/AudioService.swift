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

    func play(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: playerItem)
        
        player?.play()
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
}

