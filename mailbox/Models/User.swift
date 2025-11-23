//
//  User.swift
//  mailbox
//
//  Created by Matthew Fang on 11/22/25.
//

import Foundation
import Observation

@Observable
class User {
    var name: String
    var friendName: String
    
    init(name: String, friendName: String) {
        self.name = name
        self.friendName = friendName
    }
}
