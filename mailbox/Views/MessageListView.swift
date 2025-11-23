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
    
    @State var user: User
    
    @State var messageService: MessageService
    @State private var progress: CGFloat
    
    init(user: User) {
        self.user = user
        _messageService = State(wrappedValue: MessageService(user: user))
        self.progress = 0.1
    }
    
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
            .navigationTitle("\(user.name)'s Mailbox")
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
        .onAppear {
            messageService.startListening(for: .all)
        }
        .onDisappear {
            messageService.stopListening()
        }
    }
}

#Preview {
    MessageListView(user: User(name: "Alfred", friendName: "Matthew"))
}
