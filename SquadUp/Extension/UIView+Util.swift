//
//  UIView+Util.swift
//  SquadUp
//
//  Created by Jacob on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

extension UIView {
    
    internal func iPhoneXNavBarCorrection() {
        frame = CGRect(x: frame.minX, y: frame.minY + 24, width: frame.width, height: frame.height - 24)
    }
    
}
