//
//  User.swift
//  SquadUp
//
//  Created by Jacob on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var id: String
    
    var name: String
    
    var friendIDs: [String] = [String]()
    
    var friends: [User] = [User]()
    
    var groupIDs: [String] = [String]()
    
    var groups: [Group] = [Group]()
    
    var registrationToken: String? = nil
    
    var selected: Bool = false
    
    init(_ id: String, _ name: String) {
        self.id = id
        self.name = name
    }
    
}
