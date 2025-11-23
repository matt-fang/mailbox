//
//  OnboardingView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/22/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedName: String = "Select your name"
    var nameOptions: [String] = ["Matthew", "Alfred"]
    var friendPairs: [String: String] = ["Matthew" : "Alfred",
                                         "Alfred" : "Matthew",
                                         "Devon" : "Hayden",
                                         "Hayden" : "Devon"]
    
    var body: some View {
            
            VStack {
                Spacer()
                Image(colorScheme == .light ? "lighticon" : "darkicon")
                    .resizable()
                    .frame(width: 200, height: 200)
                VStack {
                    Text("Welcome to Voicebox")
                        .font(.system(size: 32, weight: .semibold))
                    
                    Picker("Name", selection: $selectedName) {
                        Text("My name is").tag("Select your name")
                        ForEach(nameOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.automatic)
                    .padding(.top, -10)
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
                .disabled(selectedName == "Select your name")
                .simultaneousGesture(TapGesture().onEnded {
                    UserDefaults.standard.set(selectedName, forKey: "userName")
                        
                    if let token = AppDelegate.fcmToken ?? UserDefaults.standard.string(forKey: "fcmToken") {
                        MessageService.saveFCMToken(userName: selectedName, token: token) // MARK: STATIC METHODS LET US ORGANIZE FUNCTIONS IN CLASSES WITHOUT NEEDING TO INIT AN INSTANCE! (great for semantic organization)
                    }
                })
        }
        
    }
}

#Preview {
    OnboardingView()
}
