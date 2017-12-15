//
//  Notification.Name+Notifications.swift
//  SquadUp
//
//  Created by Jacob on 12/9/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    internal static let loggedIntoGroup = Notification.Name("logged-into-group")
    
    internal static let sentLocationBack = Notification.Name("sent-location-back")
    
    internal static let readyRequest = Notification.Name("ready-request")
    
    internal static let readyResponse = Notification.Name("ready-response")
    
    internal static let readyDecision = Notification.Name("ready-decision")
    
    internal static let addedAsFriend = Notification.Name("added-as-friend")
    
    internal static let removedAsFriend = Notification.Name("removed-as-friend")
    
    internal static let addedToGroup = Notification.Name("added-to-group")
    
}
