//
//  OnboardingView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/22/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedName: String = "Alfred"
    var nameOptions: [String] = ["Matthew", "Alfred"]
    var friendPairs: [String: String] = ["Matthew" : "Alfred",
                                         "Alfred" : "Matthew",
                                         "Devon" : "Hayden",
                                         "Hayden" : "Devon"]
    
    var body: some View {
        VStack {
            Spacer()
            Image("lighticon")
                .resizable()
                .frame(width: 200, height: 200)
            VStack {
                Text("Welcome to Mailbox,")
                    .font(.system(size: 32, weight: .bold))
                
                Picker("Name", selection: $selectedName) {
                    ForEach(nameOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.automatic)
                .padding(.top, -6)
            }
            .padding(.top, 20)
            
            Spacer()
            
            NavigationLink {
                MessageListView(user: User(name: selectedName, friendName: friendPairs[selectedName] ?? "test"))
            } label: {
                Text("Continue")
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
            }
            .tint(.accentColor)
            .buttonStyle(.bordered)
            .padding()
        }
    }
}

#Preview {
    OnboardingView()
}
