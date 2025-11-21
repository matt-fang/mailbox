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
    var ref: DatabaseReference! = Database.database().reference()
    
    func setLatestMessage(_ message: String) {
        ref.child("latest-message").setValue(message)
    }

}
