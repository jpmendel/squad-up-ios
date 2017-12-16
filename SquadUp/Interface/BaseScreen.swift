//
//  BaseScreen.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit
import GoogleSignIn

class BaseScreen: UIViewController {
    
    internal required override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    internal override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = false
        initializeViews()
        screenCompatibility()
        formatScreen()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeNotificationReceiver()
    }
    
    internal override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    internal func initializeViews() { /* Override in subclass */ }
    
    internal func screenCompatibility() { /* Override in subclass */ }
    
    internal func formatScreen() { /* Override in subclass */ }
    
    internal func initializeNotificationReceiver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(addedAsFriendNotification(_:)),
            name: .addedAsFriend, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(addedToGroupNotification(_:)),
            name: .addedToGroup, object: nil
        )
    }
    
    @objc internal func addedAsFriendNotification(_ notification: Notification) {
        if let data = notification.object as? [AnyHashable: Any] {
            let senderID = data["senderID"] as! String
            let senderName = data["senderName"] as! String
            if let user = DataManager.user {
                if !user.friendIDs.contains(senderID) {
                    user.friendIDs += [senderID]
                }
                BackendManager.getUserRecord(senderID) {
                    loadedUser in
                    if let loadedUser = loadedUser {
                        if !user.friends.contains(loadedUser) {
                            user.friends += [loadedUser]
                        }
                        if let menuScreen = self as? MenuScreen {
                            menuScreen.friendsView.refreshData()
                        }
                    }
                }
            }
            view.makeToast("\(senderName) added you as a friend!", duration: 2.0, position: .bottom)
        } else {
            print("[BaseScreen] Error Parsing Notification Data: Friend Added")
        }
    }
    
    @objc internal func removedAsFriendNotification(_ notification: Notification) {
        if let data = notification.object as? [AnyHashable: Any] {
            let senderID = data["senderID"] as! String
            let senderName = data["senderName"] as! String
            if let user = DataManager.user {
                user.friendIDs.remove(object: senderID)
                for i in 0..<user.friends.count {
                    if user.friends[i].id == senderID {
                        user.friends.remove(at: i)
                        break
                    }
                }
                if let menuScreen = self as? MenuScreen {
                    menuScreen.friendsView.refreshData()
                }
            }
            view.makeToast("\(senderName) unfriended you!", duration: 2.0, position: .bottom)
        } else {
            print("[BaseScreen] Error Parsing Notification Data: Friend Removed")
        }
    }
    
    @objc internal func addedToGroupNotification(_ notification: Notification) {
        if let data = notification.object as? [AnyHashable: Any] {
            let groupID = data["groupID"] as! String
            let groupName = data["groupName"] as! String
            if let user = DataManager.user {
                if !user.groupIDs.contains(groupID) {
                    user.groupIDs += [groupID]
                }
                BackendManager.getGroupRecord(groupID) {
                    loadedGroup in
                    if let loadedGroup = loadedGroup {
                        if !user.groups.contains(loadedGroup) {
                            user.groups += [loadedGroup]
                        }
                        if let menuScreen = self as? MenuScreen {
                            menuScreen.groupsView.refreshData()
                        }
                    }
                }
            }
            view.makeToast("You have been added to the group: \(groupName)!", duration: 2.0, position: .bottom)
        } else {
            print("[BaseScreen] Error Parsing Notification Data: Group Added")
        }
    }
    
    internal func showSignOutButton() {
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut(_:)))
        navigationItem.rightBarButtonItem = signOutButton
    }
    
    @objc internal func signOut(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance().signOut()
        back(to: LoginScreen.self)
    }

}
