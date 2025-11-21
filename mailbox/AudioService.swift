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

    func play(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }

    func pause() {
        player?.pause()
    }
}

