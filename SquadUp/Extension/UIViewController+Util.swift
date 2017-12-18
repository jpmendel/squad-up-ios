//
//  UIViewController+Util.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/7/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Shows a new app stack screen on the current navigation controller.
    internal func show<T: BaseScreen>(screen: T.Type, animated: Bool = true, setup: ((T) -> Void)? = nil) {
        if self is T { return }
        if let layoutName = NSStringFromClass(screen).split(separator: ".").last {
            let viewController = screen.init(nibName: String(describing: layoutName), bundle: nil)
            if let setup = setup {
                setup(viewController)
            }
            navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    // Creates a new navigation controller and presents it on top of the current one.
    internal func present<T: BaseScreen>(screen: T.Type, animated: Bool = true, setup: ((T) -> Void)? = nil) {
        if self is T { return }
        if let layoutName = NSStringFromClass(screen).split(separator: ".").last {
            let viewController = screen.init(nibName: String(describing: layoutName), bundle: nil)
            let navigationController = UINavigationController(rootViewController: viewController)
            if let setup = setup {
                setup(viewController)
            }
            present(navigationController, animated: animated, completion: nil)
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
    
}
