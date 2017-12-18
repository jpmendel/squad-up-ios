//
//  MenuScreen.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

class MenuScreen: BaseScreen, UITabBarDelegate, UITabBarControllerDelegate {
    
    internal var groupsView: GroupsView!
    
    internal var friendsView: FriendsView!
    
    private var tabMenu: UITabBar!
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        title = "Squad Up"
        showSignOutButton()
        setupTabViews()
    }
    
    internal override func initializeViews() {
        super.initializeViews()
        groupsView = view.viewWithTag(1) as! GroupsView
        groupsView.baseScreen = self
        friendsView = view.viewWithTag(2) as! FriendsView
        friendsView.baseScreen = self
        tabMenu = view.viewWithTag(3) as! UITabBar
    }
    
    internal override func screenCompatibility() {
        super.screenCompatibility()
        if UIScreen.main.screenSize == .iPhoneX {
            groupsView.iPhoneXNavBarHeightCorrection()
            friendsView.iPhoneXNavBarHeightCorrection()
        }
    }
    
    private func setupTabViews() {
        tabMenu.delegate = self
        friendsView.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0.0)
        tabMenu.selectedItem = tabMenu.items![0]
    }
    
    internal func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Groups" {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                self.groupsView.transform = CGAffineTransform.identity
                self.friendsView.transform = CGAffineTransform.identity.translatedBy(x: self.view.frame.width, y: 0.0)
            }, completion: {
                finished in
            })
            groupsView.viewWasSelected()
        } else if item.title == "Friends" {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                self.friendsView.transform = CGAffineTransform.identity
                self.groupsView.transform = CGAffineTransform.identity.translatedBy(x: -self.view.frame.width, y: 0.0)
            }, completion: {
                finished in
            })
            friendsView.viewWasSelected()
        }
    }

}
