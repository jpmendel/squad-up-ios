//
//  Array+Util.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/13/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    internal mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
}
