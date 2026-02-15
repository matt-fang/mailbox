//
//  OnboardingView.swift
//  mailbox
//
//  Created by Matthew Fang on 11/22/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedName: String = "My name is"
    
    var nameOptions: [String] = ["Matthew", "Atharva", "Noa", "Alfred", "Devon", "Hayden"]
    var friendPairs: [String: String] = ["Matthew" : "Atharva",
                                         "Atharva" : "Matthew",
                                         "Noa" : "Alfred",
                                         "Alfred" : "Noa",
                                         "Devon" : "Hayden",
                                         "Hayden" : "Devon"]
    
    var body: some View {
            
            VStack {
                Spacer()
                Image(colorScheme == .light ? "lighticon" : "darkicon")
                    .resizable()
                    .frame(width: 200, height: 200)
                VStack(spacing: 8) {
                    Text("Welcome to Talkbox,")
                        .font(.system(size: 32, weight: .semibold))
                    
                    Picker("Select your name", selection: $selectedName) {
                        Text("My name is").tag("My name is")
                        ForEach(nameOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                .padding(.top, 20)
                
                Spacer()
                
                NavigationLink {
                    CallView(user: TalkboxUser(realName: selectedName, name: selectedName, friendName: friendPairs[selectedName] ?? "test"), audioRoomService: AudioRoomService(userName: selectedName))
                } label: {
                    Text("Continue")
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                }
                .tint(.accentColor)
                .buttonStyle(.bordered)
                .padding()
                .disabled(selectedName == "My name is")
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
