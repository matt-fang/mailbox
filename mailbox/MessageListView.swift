//
//  MessageListView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/21/25.
//

import SwiftUI

struct MessageListView: View {
    @State var messageService = MessageService()
    
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
            
            Spacer()
            
            Button {
                audioService.hasStarted ? audioService.playPause() : audioService.play(url: URL)
            } label: {
                audioService.isPlaying ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    MessageListView()
}
