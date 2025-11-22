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
                    Text(messageURL)
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

#Preview {
    MessageListView()
}
