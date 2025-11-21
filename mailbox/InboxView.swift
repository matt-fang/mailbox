//
//  ContentView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import SwiftUI
import AVFoundation

struct InboxView: View {
    @State var viewModel = InboxViewModel()
    @State var messageService = MessageService()
    @State var inputText: String = ""
    @State var audioService = AudioService()
    
    let targetAuthor = "Matthew"
    let TEST_URL = "https://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Kangaroo_MusiQue_-_The_Neverwritten_Role_Playing_Game.mp3"
    
    var body: some View {
        VStack {
            
            Text("latest message is: \(messageService.latestMessage)")
            TextField("Enter message", text: $inputText)
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("hi guys")
            
            Button {
                viewModel.setLatestMessage(inputText)
            } label: {
                Text("send message")
                    .font(.largeTitle)
            }
            
            Button {
                audioService.player?.timeControlStatus != .playing ? audioService.play(url: TEST_URL) : audioService.pause()
            } label: {
                audioService.player?.timeControlStatus != .playing ? Image(systemName: "play") : Image(systemName: "pause")
            }
            
        }
        .onAppear {
            messageService.startListening()
        }
        .onDisappear {
            messageService.stopListening()
        }
        .padding()
    }
}

#Preview {
    InboxView()
}
