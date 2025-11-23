//
//  MessageListView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/21/25.
//

import SwiftUI
internal import CoreMedia

struct MessageListView: View {
    @State var messageService = MessageService()
    @State private var progress: CGFloat = 0.1
    
    var body: some View {
            
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(messageService.allMessageURLs, id: \.self) { messageURL in
                        MessageRowView(timestamp: "Nov 21", title: "hi", URL: "https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3")
                        Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .navigationTitle("[Friend]'s Messages")
        }
        .onAppear {
            messageService.startListening(for: .all)
        }
        .onDisappear {
            messageService.stopListening()
        }
    }
}

struct MessageRowView: View {
    @State var audioService = AudioService()
    
    var timestamp: String
    var title: String
    var URL: String
    
    var body: some View {
        HStack(alignment: .center) {
            
            ZStack {
                if audioService.isPlaying {
                    PlaybackSlider(audioService: audioService)
                        .transition(.blurReplace)
                } else {
                    Text(title)
                        .transition(.blurReplace)
                }
            }
            .animation(.smooth, value: audioService.isPlaying)
            
            Spacer()
            
            Spacer()
            
            Button {
                print("BEFORE: hasStarted = \(audioService.hasStarted)")
                audioService.hasStarted ? audioService.playPause() : audioService.play(url: URL)
                print("AFTER: hasStarted = \(audioService.hasStarted)")
            } label: {
                audioService.isPlaying ? Image(systemName: "pause.fill").imageScale(.medium) : Image(systemName: "play.fill").imageScale(.medium)
            }
            .frame(width: 20, height: 20)
            
        }
    }
}

#Preview {
    MessageListView()
}
