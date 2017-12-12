//
//  BaseScreen.swift
//  SquadUp
//
//  Created by Jacob on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

class BaseScreen: UIViewController {
    
    required override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = false
        initializeViews()
        screenCompatibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeNotificationReceiver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func initializeViews() { /* Override in subclass */ }
    
    func screenCompatibility() { /* Override in subclass */ }
    
    func initializeNotificationReceiver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(addedAsFriendNotification(_:)),
            name: .addedAsFriend, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(addedToGroupNotification(_:)),
            name: .addedToGroup, object: nil
        )
    }
    
    @objc func addedAsFriendNotification(_ notification: Notification) {
        
    }
    
    @objc func addedToGroupNotification(_ notification: Notification) {
        
    }

}
