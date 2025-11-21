//
//  ContentView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import SwiftUI

struct InboxView: View {
    @State var viewModel = InboxViewModel()
    
    var body: some View {
        VStack {
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
        }
        .padding()
    }
}

#Preview {
    InboxView()
}
