//
//  Notification.Name+Notifications.swift
//  SquadUp
//
//  Created by Jacob on 12/9/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let loggedIntoGroup = Notification.Name("logged-into-group")
    
    static let sentLocationBack = Notification.Name("sent-location-back")
    
    static let readyRequest = Notification.Name("ready-request")
    
    static let readyResponse = Notification.Name("ready-response")
    
    static let readyDecision = Notification.Name("ready-decision")
    
    static let addedAsFriend = Notification.Name("added-as-friend")
    
    static let removedAsFriend = Notification.Name("removed-as-friend")
    
    static let addedToGroup = Notification.Name("added-to-group")
    
}
