//
//  User.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import Foundation

class User: NSObject {
    
    internal var id: String
    
    internal var name: String
    
    internal var friendIDs: [String] = [String]()
    
    internal var friends: [User] = [User]()
    
    internal var groupIDs: [String] = [String]()
    
    internal var groups: [Group] = [Group]()
    
    internal var registrationToken: String? = nil
    
    internal var selected: Bool = false
    
    init(_ id: String, _ name: String) {
        self.id = id
        self.name = name
    }
    
}
