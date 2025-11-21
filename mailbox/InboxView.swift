//
//  ContentView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import SwiftUI

struct InboxView: View {
    @State var viewModel = InboxViewModel()
    
    @State var inputText: String = ""
    
    let targetAuthor = "Matthew"
    var latestMessage: String = ""
    
    var body: some View {
        VStack {
            
            TextField("Enter message", text: $inputText)
                .onChange(of: inputText) { _ in
                    viewModel.setLatestMessage(inputText)
                }
            
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
        .padding()
    }
}

#Preview {
    InboxView()
}
