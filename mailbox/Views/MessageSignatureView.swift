//
//  MessageSignatureView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/22/25.
//

import SwiftUI

struct MessageSignatureView: View {
    @State var user: User
    
    var body: some View {
        VStack {
            Text("\(user.friendName) → \(user.name)")
                .font(.system(size: 10, design: .monospaced))
        }
        .padding(.horizontal, 6)
        
    }
}

#Preview {
    MessageSignatureView(user: User(name: "Alfred", friendName: "Matthew"))
}
