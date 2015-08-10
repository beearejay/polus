//
//  behaviourOrbitView.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 24/06/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//  New

import UIKit

class BehaviourOrbitView: UIView {
    
    var id = 0 {
        didSet {
            //self.backgroundColor = behaviourColourArray[(id*2) + 1]
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = frame.height/2
        self.clipsToBounds = true
    }

    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect){
        var context = UIGraphicsGetCurrentContext()
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        var colors: [CGColor] = [behaviourOrbitColourArray[id*2].CGColor, behaviourOrbitColourArray[(id*2) + 1].CGColor]
        //var colors: [CGColor] = [UIColor.blueColor().CGColor, UIColor.redColor().CGColor]
        var locations: [CGFloat] = [0.5, 1.0]
        var gradient = CGGradientCreateWithColors(colorSpace, colors, locations)
        var relativeCenter = CGPointMake(frame.width/2, frame.height/2)
        CGContextDrawRadialGradient(context, gradient, relativeCenter, CGFloat(circleDiameter/6), relativeCenter, CGFloat(self.frame.width/2), CGGradientDrawingOptions(kCGGradientDrawsAfterEndLocation))
        
        self.layer.cornerRadius = frame.height/2
    }
}
