//
//  PlaybackSlider.swift
//  mailbox
//
//  Created by Matthew Fang on 11/22/25.
//

import SwiftUI

struct PlaybackSlider: View {
    @Binding var value: CGFloat
    var range: ClosedRange<CGFloat>
    var extraHeight: CGFloat

    @State private var lastStoredValue: CGFloat
    @GestureState private var isActive: Bool = false
    
    init(value: Binding<CGFloat>, in range: ClosedRange<CGFloat>) {
        self._value = value
        self.range = range
        self.extraHeight = 10
        self.lastStoredValue = value.wrappedValue
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
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
                .onChanged { value in
                    let progress = (value.translation.width / size.width) * range.upperBound + self.lastStoredValue
                    self.value = max(min(progress, range.upperBound), range.lowerBound)
                }.onEnded { _ in
                    lastStoredValue = value
                }
            )
            .frame(height: 5 + extraHeight)
            .mask {
                RoundedRectangle(cornerRadius: .infinity)
                    .frame(height: isActive ? 5 + extraHeight : 5)
            }
            .animation(.smooth(duration: 0.3), value: isActive)
        }
    }

    
}
