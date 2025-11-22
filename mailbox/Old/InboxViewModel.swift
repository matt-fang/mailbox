//
//  InboxViewModel.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import Foundation
import Observation

@Observable final class InboxViewModel {
    let firestore = FirestoreManager()
    let realtimeDatabase = RealtimeDatabaseManager()
    
    var firstMessage: String = ""
    
    // MARK: Realtime Database methods
    
    func setLatestMessage(_ message: String) {
        realtimeDatabase.setLatestMessage(message)
    }
    
    // MARK: Firestore methods
    
    func addData(_ message: String, from author: String) {
        Task {
            do {
                try await firestore.addData(message, from: author)
            } catch {
                print("Error adding data: \(error.localizedDescription)")
            }
        }
    }
    
    func retrieveFirstMessage(from author: String){
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
