//
//  ActivityService.swift
//  mailbox
//
//  Created by Matthew Fang on 2/13/26.
//

import Foundation
import FirebaseDatabase

final class ActivityService {
    private let ref: DatabaseReference

    init(userId: String) {
        self.ref = Database.database().reference().child("\(userId)/isActive")
    }

    func setActive(_ active: Bool) {
        ref.setValue(active)
    }
}
