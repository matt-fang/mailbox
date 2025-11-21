//
//  RealtimeDatabaseManager.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

final class RealtimeDatabaseManager {
    var msgRef: DatabaseReference! = Database.database().reference().child("latestMessage")
    
    func setLatestMessage(_ message: String) {
        msgRef.setValue(message)
    }
    
    func getLatestMessage() {
        return
    }

}
