//
//  MessageListViewModel.swift
//  mailbox
//
//  Created by Matthew Fang on 11/21/25.
//

import Foundation
import Observation
import FirebaseCore
import FirebaseDatabase

@Observable
final class MessageListViewModel {
    let firestore = FirestoreManager()
    let realtimeDatabase = RealtimeDatabaseManager()
    
    var firstMessage: String = ""
    
    func getAllMessages(from author: String){
        Task {
            do {
                let message = try await firestore.getFirstMessage(from: author)
                self.firstMessage = message
            } catch {
                print("Error getting message: \(error.localizedDescription)")
            }
        }
    }
    
}
