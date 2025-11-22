//
//  mailboxApp.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import SwiftUI
import Firebase

@main
struct mailboxApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MessageListView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("configured firebase")
        
        return true
    }
}
