//
//  ContentView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import SwiftUI

struct InboxView: View {
    @State var viewModel = InboxViewModel()
    @State var messageService = MessageService()
    @State var inputText: String = ""
    
    let targetAuthor = "Matthew"
    
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
