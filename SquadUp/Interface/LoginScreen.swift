//
//  LoginScreen.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/9/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginScreen: BaseScreen, GIDSignInDelegate, GIDSignInUIDelegate {

    internal override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleSignIn()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Squad Up"
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    internal override func initializeViews() {
        super.initializeViews()
    }
    
    internal func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
    
    internal func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let userEmail = user.profile.email!
            let userName = user.profile.name!
            BackendManager.getUserRecord(userEmail) {
                loadedUser in
                if loadedUser == nil {
                    let newUser = User(userEmail, userName)
                    BackendManager.createUserRecord(newUser)
                    DataManager.user = newUser
                } else {
                    DataManager.user = loadedUser
                }
                BackendManager.getFriendData(for: DataManager.user!) {
                    userWithFriends in
                    BackendManager.getGroupData(for: DataManager.user!) {
                        userWithGroups in
                        DataManager.updateCurrentUserRegistration() {
                            self.show(screen: MenuScreen.self)
                        }
                    }
                }
            }
        }
    }
    
    internal func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }

}
