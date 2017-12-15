//
//  Group.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import Foundation

class Group: NSObject {
    
    internal var id: String
    
    internal var name: String
    
    internal var memberIDs: [String] = [String]()
    
    internal var members: [User] = [User]()
    
    init(_ id: String, _ name: String) {
        self.id = id
        self.name = name
    }
    
    init(withName name: String) {
        let formattedName = name.replacingOccurrences(of: " ", with: "-").lowercased()
        self.id = formattedName + "-" + NSUUID().uuidString
        self.name = name
    }
    
}
