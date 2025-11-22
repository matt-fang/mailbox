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
            List {
                ForEach(messageService.allMessageURLs, id: \.self) { messageURL in
                    MessageRowView(timestamp: "Nov 21", title: "hi", URL: "https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3")
                }
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
        HStack {
            Text(title)
            
            PlaybackSlider(audioService: audioService)
            
            Spacer()
            
            Button {
                audioService.hasStarted ? audioService.playPause() : audioService.play(url: URL)
            } label: {
                audioService.isPlaying ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

#Preview {
    MessageListView()
}
