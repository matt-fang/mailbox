//
//  MessageListView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/21/25.
//

import SwiftUI
internal import CoreMedia
import StreamVideo

struct CallView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State var user: TalkboxUser
    var autoConnect: Bool = false
    var audioRoomService: AudioRoomService
    
    var body: some View {
        VStack {
            Button {
                print("join call button")
                Task {
                    await audioRoomService.isConnected ? audioRoomService.disconnect() : audioRoomService.connect()
                }
                
            } label: {
                Image(systemName: audioRoomService.isConnected ? "pause.fill" : "play.fill")
                    .font(.system(size: 200))
            }
            
            
            if audioRoomService.isConnected,
               let callId = audioRoomService.call?.callId,
               let participantCount = audioRoomService.call?.state.participantCount {
                Text("audio room \(callId) has \(participantCount) participants")
            }
            
        }
        .navigationTitle("\(user.realName)'s Talkbox")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "person.circle")
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if autoConnect && !audioRoomService.isConnected {
                Task {
                    await audioRoomService.connect()
                }
            }
        }
    }
}

#Preview {
    CallView(user: TalkboxUser(realName: "Matthew", name: "Matthew", friendName: "Alfred"), audioRoomService: AudioRoomService(userName: "Matthew"))
}
