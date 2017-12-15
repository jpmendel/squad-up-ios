//
//  AppDelegate.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    internal var window: UIWindow?
    
    private func configureServices(_ application: UIApplication) {
        DataManager.configure()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    private func registerForNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.appMediumBlue
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UITabBar.appearance().tintColor = UIColor.orange
    }
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: LaunchScreen())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureServices(application)
        setupAppearance()
        setupWindow()
        return true
    }
    
    @available(iOS 9.0, *)
    internal func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    internal func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("[AppDelegate] Registration Token: \(fcmToken)")
    }
    
    internal func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        if !remoteMessage.appData.isEmpty {
            let messageType = remoteMessage.appData["type"] as! String
            if messageType == FirebaseMessage.login {
                NotificationCenter.default.post(name: .loggedIntoGroup, object: remoteMessage.appData)
            } else if messageType == FirebaseMessage.location {
                NotificationCenter.default.post(name: .sentLocationBack, object: remoteMessage.appData)
            } else if messageType == FirebaseMessage.readyRequest {
                NotificationCenter.default.post(name: .readyRequest, object: remoteMessage.appData)
            } else if messageType == FirebaseMessage.readyResponse {
                NotificationCenter.default.post(name: .readyResponse, object: remoteMessage.appData)
            } else if messageType == FirebaseMessage.readyDecision {
                NotificationCenter.default.post(name: .readyDecision, object: remoteMessage.appData)
            } else if messageType == FirebaseMessage.addedAsFriend {
                NotificationCenter.default.post(name: .addedAsFriend, object: remoteMessage.appData)
            } else if messageType == FirebaseMessage.removedAsFriend {
                NotificationCenter.default.post(name: .removedAsFriend, object: remoteMessage.appData)
            } else if messageType == FirebaseMessage.addedToGroup {
                NotificationCenter.default.post(name: .addedToGroup, object: remoteMessage.appData)
            }
        }
    }
    
    internal func applicationWillResignActive(_ application: UIApplication) {}
    
    internal func applicationDidEnterBackground(_ application: UIApplication) {}
    
    internal func applicationWillEnterForeground(_ application: UIApplication) {}
    
    internal func applicationDidBecomeActive(_ application: UIApplication) {}
    
    internal func applicationWillTerminate(_ application: UIApplication) {}

}

