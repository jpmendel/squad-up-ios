//
//  LaunchScreen.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

class LaunchScreen: BaseScreen {
    
    private var statusBarBackground: UIView!
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.show(screen: LoginScreen.self)
        }
    }
    
    internal override func initializeViews() {
        super.initializeViews()
        statusBarBackground = view.viewWithTag(1)
    }
    
    internal override func screenCompatibility() {
        super.screenCompatibility()
        if UIScreen.main.screenSize == .iPhoneX {
            statusBarBackground.frame = CGRect(
                x: statusBarBackground.frame.minX, y: statusBarBackground.frame.minY,
                width: statusBarBackground.frame.width, height: statusBarBackground.frame.height + 24
            )
        }
    }

}
