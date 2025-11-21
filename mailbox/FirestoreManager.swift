//
//  FirestoreManager.swift
//  mailbox
//
//  Created by Matthew Fang on 11/20/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class FirestoreManager {
    func addData(_ message: String, from author: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("messages").addDocument(data: [
            "message": message,
            "author": author,
            "timestamp": Date()
        ])
    }
}
