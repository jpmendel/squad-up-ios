//
//  UIViewController+Util.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Shows a new app stack screen.
    internal func show<T: BaseScreen>(screen: T.Type, animated: Bool = true, setup: ((_ destination: BaseScreen) -> Void)? = nil) {
        if self is T { return }
        if let layoutName = NSStringFromClass(screen).split(separator: ".").last {
            let viewController = screen.init(nibName: String(describing: layoutName), bundle: nil)
            if let setupFunction = setup {
                setupFunction(viewController)
            }
            navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    // Goes back to the last viewed screen.
    internal func back(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    // Goes back to a screen of a specific type.
    internal func back<T: BaseScreen>(to screen: T.Type, animated: Bool = true) {
        if self is T { return }
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is T {
                    navigationController?.popToViewController(viewController, animated: animated)
                }
            }
        }
    }
    
    internal func createConfirmAlert(title: String, message: String, callback: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: callback)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}
