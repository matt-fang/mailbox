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
    
    func addData(_ message: String, from author: String) {
        Task {
            do {
                try await firestore.addData(message, from: author)
            } catch {
                print("Error adding data: \(error.localizedDescription)")
            }
        }
        
    }
}
