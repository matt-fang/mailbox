//
//  ContentView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import SwiftUI

struct InboxView: View {
    @State var viewModel = InboxViewModel()
    let targetAuthor = "Matthew"
    var latestMessage: String = ""
    
    var body: some View {
        VStack {
//            Text("Latest message from \(targetAuthor): \(latestMessage)")
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("hi guys")
            
            Button {
                viewModel.addData("hello", from: "Matthew")
            } label: {
                Text("send message")
                    .font(.largeTitle)
            }
            
//            Button {
//                latestMessage = viewModel.retrieveFirstMessage(from: targetAuthor)
//            } label: {
//                Text("check messages")
//                    .font(.largeTitle)
//            }
            
        }
        .padding()
    }
}

#Preview {
    InboxView()
}
