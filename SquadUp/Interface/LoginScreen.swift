//
//  LoginScreen.swift
//  SquadUp
//
//  Created by Jacob on 12/9/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class LoginScreen: BaseScreen, GIDSignInDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Squad Up"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func initializeViews() {
        super.initializeViews()
    }
    
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
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
                print("USER: \(DataManager.user!.id), \(DataManager.user!.name)")
                self.show(screen: MenuScreen.self)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }

}
