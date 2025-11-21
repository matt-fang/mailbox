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
    var latestMessage: String = ""
    
    var messageHandle: DatabaseHandle?
    var ref: DatabaseReference! = Database.database().reference().child("latestMessage")
    
    func startListening() {
        messageHandle = ref.observe(.value) { snapshot in
            if let data = snapshot.value as? String {
                print("new message! \(data)")
                self.latestMessage = data
            }
        }
    }
    
    func stopListening() {
        guard let handle = messageHandle else { return }
        ref.removeObserver(withHandle: handle)
    }
}
