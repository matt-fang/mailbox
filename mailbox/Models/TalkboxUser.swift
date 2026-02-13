//
//  User.swift
//  mailbox
//
//  Created by Matthew Fang on 11/22/25.
//

import Foundation
import Observation

@Observable
class TalkboxUser {
    var realName: String
    var name: String
    var friendName: String
    
    init(realName: String, name: String, friendName: String) {
        self.realName = realName
        self.name = name
        self.friendName = friendName
    }
}
