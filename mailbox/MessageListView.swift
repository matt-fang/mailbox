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
                    ForEach(messageService.allMessages) { message in
                        MessageRowView(messageService: messageService, message: message)
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
    @State var audioService: AudioService
    @State var messageService: MessageService
    
    var message: Message
    var date: String
    var URL: String
    
    init(messageService: MessageService, message: Message) {
        self.audioService = AudioService()
        self.messageService = messageService
        
        self.message = message
        self.date = message.date
        self.URL = message.URL
        print("URL IS \(self.URL)")
    }
    
    var body: some View {
        HStack(alignment: .center) {
            
            if message.isRead == false {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(.blue)
            }
                
            ZStack {
                if audioService.isPlaying {
                    PlaybackSlider(audioService: audioService)
                        .transition(.blurReplace)
                } else {
                    Text(date)
                        .transition(.blurReplace)
                }
            }
            .animation(.smooth, value: audioService.isPlaying)
            
            Spacer()
            
            Spacer()
            
            Button {
                audioService.hasStarted ? audioService.playPause() : audioService.play(url: self.URL)
                
                messageService.markIsRead(for: message.date)
                message.isRead = true
                
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
