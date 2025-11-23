//
//  AudioService.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import Foundation
import AVFoundation
import Observation
import SwiftUI

@Observable
final class AudioService {
    var player: AVPlayer?
    var isPlaying: Bool = false
    var hasStarted: Bool = false
    var duration: CGFloat = 0
    
    private var observer: Any?
    
    var time: CGFloat?
    
    var gestureIsActive: Bool? = false
    
    func play(url: String) {
        // MARK: AVPlayer will NOT play http urls!
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
        print("CALLED PLAYPAUSE")
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        
        isPlaying.toggle()
    }
    
    func pause() {
        player?.pause()
    }
    
    func startTimeListener() {
        
        stopTimeListener()
        
        let interval = CMTime(seconds: 0.05, preferredTimescale: 600)
        
        self.observer = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] time in
            
            if self?.gestureIsActive == false {
                self?.time = CGFloat(time.seconds)
                
                if CGFloat(time.seconds) >= self?.duration ?? .infinity {
                    self?.time = CGFloat(0.0)
                    self?.player?.seek(to: .zero)
                    self?.pause()
                    self?.isPlaying = false
                }
            }
            
//            print("NEW TIME: \(time)")
//            print("TIME SHOULD UPDATE? \(self?.gestureIsActive)")
//            print("TIME IS: \(self?.time)")
        }
    }
    
    func stopTimeListener() {
        if let ob = self.observer {
            player?.removeTimeObserver(ob)
        }
    }
    
    func sliderSeek(to time: CGFloat) {
        let newTime = CMTime(seconds: Double(time), preferredTimescale: 600)
        player?.seek(to: newTime) { finished in
            // Only resume playing after seek completes
            if finished {
                self.isPlaying.toggle()
                self.playPause()
            }
        }
        self.time = CGFloat(newTime.seconds)
    }
}

