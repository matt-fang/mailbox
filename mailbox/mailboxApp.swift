//
//  mailboxApp.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications

@main
struct mailboxApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                OnboardingView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    static var fcmToken: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("configured firebase")
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
            guard success else {
                return
            }
            print("success apns registration!")
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for APNS")
        Messaging.messaging().apnsToken = deviceToken // GIVE FIREBASE YOUR APNS TOKEN
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM token received: \(fcmToken ?? "nil")")
        
        guard let token = fcmToken else {
            print("FCM token is nil")
            return
        }
        
        print("Valid FCM token: \(token)")
        
        AppDelegate.fcmToken = token
        UserDefaults.standard.set(token, forKey: "fcmToken")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // show notif even in foreground?
        completionHandler([[.banner, .sound]])
    }
    
}
