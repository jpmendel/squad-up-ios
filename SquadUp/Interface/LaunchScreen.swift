//
//  LaunchScreen.swift
//  SquadUp
//
//  Created by Jacob on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

class LaunchScreen: BaseScreen {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.show(screen: LoginScreen.self)
        }
    }

}
