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
    
    private var signInButton: GIDSignInButton!
    
    private var loadingIndicator: UIActivityIndicatorView!

    internal override func viewDidLoad() {
        super.viewDidLoad()
        title = "Squad Up"
        setupGoogleSignIn()
    }
    
    internal override func initializeViews() {
        super.initializeViews()
        signInButton = view.viewWithTag(1) as! GIDSignInButton
        loadingIndicator = view.viewWithTag(2) as! UIActivityIndicatorView
    }
    
    internal func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        signInButton.style = .standard
        signInButton.center = CGPoint(x: view.frame.width / 2 - 18, y: signInButton.center.y)
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        signInButton.isHidden = false
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    internal func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            signInButton.isHidden = true
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
            let userEmail = user.profile.email!
            let userName = user.profile.name!
            BackendManager.getUserRecord(userEmail) {
                loadedUser in
                if loadedUser == nil {
                    let newUser = User(userEmail, userName)
                    BackendManager.createUserRecord(newUser)
                    BackendManager.addUserToUserList(newUser.id)
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
        print("[LoginScreen] User Disconnected")
    }

}
