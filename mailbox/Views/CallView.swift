//
//  MessageListView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/21/25.
//

import SwiftUI
internal import CoreMedia

struct CallView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State var user: TalkboxUser
    @State var isPlaying: Bool = false
    var audioRoomService: AudioRoomService = AudioRoomService()
    
    var body: some View {
        VStack {
            Button {
                print("join call button")
                Task {
                    await isPlaying ? audioRoomService.disconnect() : audioRoomService.connect()
                }
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 200))
            }
        }
        .navigationTitle("\(user.realName)'s Voicebox")
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
    }
}

#Preview {
    CallView(user: TalkboxUser(realName: "Matthew", name: "Matthew", friendName: "Alfred"))
}
