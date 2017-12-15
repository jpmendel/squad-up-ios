//
//  UIScreen+Util.swift
//  SquadUp
//
//  Created by Jacob on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

extension UIScreen {
    
    internal enum ScreenSize: CGFloat {
        case unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone8 = 1334.0
        case iPhone8Plus = 1920.0
        case iPhoneX = 2436.0
    }
    
    internal var screenSize: ScreenSize {
        if let screenSize = ScreenSize(rawValue: nativeBounds.height) {
            return screenSize
        }
        return .unknown
    }
    
}
