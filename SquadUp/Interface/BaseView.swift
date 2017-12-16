//
//  BaseView.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    internal var baseScreen: BaseScreen!
    
    internal var view: UIView!
    
    internal required override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    internal override func awakeFromNib() {
        super.awakeFromNib()
        initializeViews()
        screenCompatibility()
        formatScreen()
    }

    private func loadXibFile() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xibName = type(of: self).description().components(separatedBy: ".").last!
        let xib = UINib(nibName: xibName, bundle: bundle)
        return xib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    private func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadXibFile()
        view.frame = bounds
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[childView]|",
            options: [],
            metrics: nil,
            views: ["childView": view])
        )
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[childView]|",
            options: [],
            metrics: nil,
            views: ["childView": view])
        )
    }
    
    internal func initializeViews() { /* Override in subclass */ }
    
    internal func screenCompatibility() { /* Override in subclass */ }
    
    internal func formatScreen() { /* Override in subclass */ }

}
