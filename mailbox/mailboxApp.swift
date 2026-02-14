import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications

@main
struct mailboxApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var audioRoomService: AudioRoomService
    @State private var deepLinkToCall = false
    @Environment(\.scenePhase) private var scenePhase

    // Computed property instead of stored property
    private var name: String {
        UserDefaults.standard.string(forKey: "userName") ?? "test"
    }

    private var friendPairs: [String: String] {
        ["Matthew": "Atharva", "Atharva": "Matthew",
         "Noa": "Alfred", "Alfred": "Noa",
         "Devon": "Hayden", "Hayden": "Devon"]
    }

    init() {
        // Configure Firebase BEFORE creating AudioRoomService
        FirebaseApp.configure()

        let userName = UserDefaults.standard.string(forKey: "userName") ?? "test"
        _audioRoomService = State(wrappedValue: AudioRoomService(userName: userName))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                OnboardingView()
                    .navigationDestination(isPresented: $deepLinkToCall) {
                        CallView(
                            user: TalkboxUser(
                                realName: name,
                                name: name,
                                friendName: friendPairs[name] ?? "test"
                            ),
                            autoConnect: true,
                            audioRoomService: audioRoomService
                        )
                    }
            }
            .onOpenURL { url in
                deepLinkToCall = true
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                switch newPhase {
                case .background:
                    print("App entering background - disconnecting")
                case .inactive:
                    Task {
                        await audioRoomService.disconnect()
                    }
                    print("App becoming inactive")
                case .active:
                    print("App becoming active")
                @unknown default:
                    break
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    static var fcmToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Firebase already configured in App init
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
        Messaging.messaging().apnsToken = deviceToken
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
        completionHandler([[.banner, .sound]])
    }
}
