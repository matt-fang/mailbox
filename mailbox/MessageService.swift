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
    var messageHandle: DatabaseHandle?
    
    // MARK: 'CHILDREN' ARE JUST KEYS - ITEMS IN A NESTED LIST
    var latestMessage: String = ""
    var latestRef: DatabaseReference! = Database.database().reference().child("users/Matthew/latestMessage")

    var allMessageURLs: [String] = []
    var allMessagesRef: DatabaseReference! = Database.database().reference().child("users/Matthew/allMessages")
    
    var ref: DatabaseReference!
    
    func startListening(for type: ListenerType) {
        
        ref = type == .latest ? latestRef : allMessagesRef
        
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
                self.allMessageURLs.removeAll()
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let data = childSnapshot.value as? String {
                        print("new data! \(data)")
                        self.allMessageURLs.append(data)
                    }
                }
                self.allMessageURLs.reverse()
            }
        }
    }
    
    func stopListening() {
        guard let handle = messageHandle else { return }
        ref.removeObserver(withHandle: handle)
    }
    
    enum ListenerType {
        case latest
        case all
    }
}
