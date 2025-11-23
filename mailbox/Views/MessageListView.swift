//
//  MessageListView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/21/25.
//

import SwiftUI
internal import CoreMedia

struct MessageListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State var user: User
    
    @State var messageService: MessageService
    @State private var progress: CGFloat
    
    init(user: User) {
        self.user = user
        _messageService = State(wrappedValue: MessageService(user: user))
        self.progress = 0.1
    }
    
    var body: some View {
        ZStack{
            if messageService.allMessages.isEmpty {
                VStack {
                    Image(systemName: "tray")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75)
                        .foregroundStyle(.quaternary)
                    
                    Text("No messages yet.")
                        .multilineTextAlignment(.center)
                        .monospaced()
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 16)

                }
                
            } else {
                ScrollView {
                    LazyVStack(spacing: 22) {
                        ForEach(messageService.allMessages) { message in
                            MessageRowView(messageService: messageService, message: message)
                            Divider()
                                .gridCellUnsizedAxes(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
            }
        }
        .navigationTitle("\(user.name)'s Voicebox")
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
            messageService.startListening(for: .all)
        }
        .onDisappear {
            messageService.stopListening()
        }
    }
}

#Preview {
    MessageListView(user: User(name: "Matthew", friendName: "Alfred"))
}
