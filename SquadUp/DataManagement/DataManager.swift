//
//  DataManager.swift
//  SquadUp
//
//  Created by Jacob on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import Foundation

class DataManager {
    
    static var user: User? = nil
    
    static func configure() {
        user = User("test@email.com", "Test User")
        user!.friendIDs = ["person1@email.com", "person2@email.com"]
        user!.friends = [User("person1@email.com", "Person One"), User("person2@email.com", "Person Two")]
        user!.groupIDs = ["Good Group", "Test Group", "Another Group"]
        user!.groups = [Group(withName: "Good Group"), Group(withName: "Test Group"), Group(withName: "Another Group")]
    }
    
}
