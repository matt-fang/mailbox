//
//  MessageListenerManager.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import Foundation
import Observation
import FirebaseCore
import FirebaseDatabase

@Observable
final class MessageService {
    var user: User
    var messageHandle: DatabaseHandle?
    
    // MARK: 'CHILDREN' ARE JUST KEYS - ITEMS IN A NESTED LIST
    var latestMessage: String
    var latestRef: DatabaseReference!

    var allMessages: [Message]
    var allMessagesRef: DatabaseReference!
    
    var ref: DatabaseReference!
    
    init(user: User) {
        self.user = user
        self.latestMessage = ""
        self.latestRef = Database.database().reference().child("users/\(user.friendName)/latestMessage")
        self.allMessages = []
        self.allMessagesRef = Database.database().reference().child("users/\(user.friendName)/allMessages")
    }
    
    static func saveFCMToken(userName: String, token: String) {
        Database.database().reference()
            .child("users/\(userName)/fcmToken")
            .setValue(token)
    }
    
    func startListening(for type: ListenerType) {
        
        ref = type == .latest ? latestRef : allMessagesRef
        let URLRef = ref.child("URL")
        let isReadRef = ref.child("isRead")
        
        if type == .latest {
            messageHandle = ref.observe(.value) { snapshot in
                if let data = snapshot.value as? String {
                    print("new latest message! \(data)")
                    self.latestMessage = data
                }
            }
        }
        else if type == .all {
            
            messageHandle = ref.observe(.value) { snapshot in
                var messages: [Message] = []
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let messageData = childSnapshot.value as? [String: Any],
                       let urlData = messageData["URL"] as? String,
                       let isReadData = messageData["isRead"] as? Bool
                    {
                        messages.append(Message(date: childSnapshot.key, URL: urlData, isRead: isReadData))
                    }
                }
                self.allMessages = messages.sorted(by: >)
            }
        }
    }
    
    func stopListening() {
        guard let handle = messageHandle else { return }
        ref.removeObserver(withHandle: handle)
    }
    
    func markIsRead(for key: String) {
        ref = self.allMessagesRef.child(key).child("isRead")
        ref.setValue(true)
    }
    
    func getIsRead(for key: String) {
        ref = self.allMessagesRef.child(key).child("isRead")
        ref.setValue(true)
        return
    }
    
    enum ListenerType {
        case latest
        case all
    }
}

class Message: Identifiable, Comparable, Equatable {
    var date: String
    var URL: String
    var isRead: Bool
    
    var id: String { date }
    
    init(date: String, URL: String, isRead: Bool) {
        self.date = date
        self.URL = URL
        self.isRead = isRead
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        lhs.date < rhs.date
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.date == rhs.date
    }
}
