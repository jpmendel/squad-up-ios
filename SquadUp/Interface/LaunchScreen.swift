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
    
    private var loadingImage: UIImageView!
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        startAnimatingLoadingImage()
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BackendManager.getUserList() {
            userList in
            DataManager.userList = userList
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.stopAnimatingLoadingImage()
            self.present(screen: LoginScreen.self)
        }
    }
    
    internal override func initializeViews() {
        super.initializeViews()
        statusBarBackground = view.viewWithTag(1)
        loadingImage = view.viewWithTag(2) as! UIImageView
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
    
    private func startAnimatingLoadingImage() {
        loadingImage.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        loadingImage.center = CGPoint(x: loadingImage.center.x, y: loadingImage.center.y + loadingImage.frame.height / 2)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.loadingImage.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 1.1)
        }, completion: {
            finished in
        })
    }
    
    private func stopAnimatingLoadingImage() {
        loadingImage.layer.removeAllAnimations()
    }

}
