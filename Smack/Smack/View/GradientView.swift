//
//  GradientView.swift
//  Smack
//
//  Created by Kevin Keefe on 11/27/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import UIKit

// IBDesignable -- can update in StoryBoard
@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var topColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.7843137255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }

    @IBInspectable var bottomColor = #colorLiteral(red: 0.3137254902, green: 0.6862745098, blue: 0.7843137255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    

}
