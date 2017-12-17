//
//  DataManager.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import Foundation
import Firebase

class DataManager {
    
    internal static var user: User? = nil
    
    internal static var group: Group? = nil
    
    internal static var userList = [String]()
    
    internal static func configure() {
        user = User("test@email.com", "Test User")
        user!.friendIDs = ["person1@email.com", "person2@email.com"]
        user!.friends = [User("person1@email.com", "Person One"), User("person2@email.com", "Person Two")]
        user!.groupIDs = ["Good Group", "Test Group", "Another Group"]
        user!.groups = [Group(withName: "Good Group"), Group(withName: "Test Group"), Group(withName: "Another Group")]
    }
    
    internal static func updateCurrentUserRegistration(callback: (() -> Void)? = nil) {
        if let user = user {
            if user.registrationToken != Messaging.messaging().fcmToken {
                user.registrationToken = Messaging.messaging().fcmToken
                BackendManager.createUserRecord(user, callback: callback)
            } else {
                if let callback = callback {
                    callback()
                }
            }
        }
    }
    
}
