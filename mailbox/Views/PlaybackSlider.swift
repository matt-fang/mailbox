//
//  PlaybackSlider.swift
//  mailbox
//
//  Created by Matthew Fang on 11/22/25.
//

import SwiftUI

struct PlaybackSlider: View {
    @Bindable var audioService: AudioService
    var range: ClosedRange<CGFloat>
    var extraHeight: CGFloat

    @State private var lastStoredValue: CGFloat
    @GestureState var isActive: Bool = false
    
    init(audioService: AudioService) {
        self.audioService = audioService
        self.range = 0...(audioService.duration)
        self.extraHeight = 10
        self.lastStoredValue = 0.0
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            var value = CGFloat(audioService.time ?? 0.0)
            
            let width = (value / range.upperBound) * size.width
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundStyle(.quaternary)
                Rectangle()
                    .foregroundStyle(.primary)
                    .mask(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                    }
            }
            .clipShape(.rect(cornerRadius: .infinity))
            .contentShape(.rect(cornerRadius: .infinity))
            .highPriorityGesture(DragGesture(minimumDistance: 0)
                .updating($isActive) { _, out, _ in
                    out = true
                }
                .onChanged { newValue in
                    audioService.gestureIsActive = true
                    audioService.pause()
                    let progress = (newValue.translation.width / size.width) * range.upperBound + self.lastStoredValue
                    let newTime = max(min(progress, range.upperBound), range.lowerBound)
                    audioService.time = newTime  // ← FIX: Update audioService.time here!
                }
                .onEnded { _ in
                    audioService.sliderSeek(to: value)
                    lastStoredValue = value  // ← FIX: Update lastStoredValue after seek
                    audioService.gestureIsActive = false  // ← FIX: Reset gesture state
                }
            )
            .frame(height: 10 + extraHeight)
            .mask {
                RoundedRectangle(cornerRadius: .infinity)
                    .frame(height: isActive ? 5 + extraHeight : 5)
            }
            .animation(.smooth(duration: 0.3), value: isActive)
        }
    }

    
}
