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
    
    let db = Firestore.firestore()
    
    func addData(_ message: String, from author: String) async throws {
        try await db.collection("messages").addDocument(data: [
            "message": message,
            "author": author,
            "timestamp": Date()
        ])
    }
    
    func getFirstMessage(from author: String) async throws -> String {
        let querySnapshot = try await db.collection("messages")
            .whereField("author", isEqualTo: author)
            .getDocuments()
        let data = querySnapshot.documents.first?.data()
        return data?["message"] as? String ?? ""
    }
    
}
