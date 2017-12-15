//
//  BaseScreen.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

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
        
    }
    
    @objc internal func addedToGroupNotification(_ notification: Notification) {
        
    }

}
