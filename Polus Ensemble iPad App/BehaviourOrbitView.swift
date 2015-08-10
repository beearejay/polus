//
//  behaviourOrbitView.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 24/06/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import UIKit

@IBDesignable
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
        var locations: [CGFloat] = [0.0, 0.9]
        var gradient = CGGradientCreateWithColors(colorSpace, colors, locations)
        var relativeCenter = CGPointMake(frame.width/2, frame.height/2)
        //CGContextDrawRadialGradient(<#context: CGContext!#>, gradient: CGGradient!, <#startCenter: CGPoint#>, <#startRadius: CGFloat#>, <#endCenter: CGPoint#>, //, <#options: CGGradientDrawingOptions#>)
        CGContextDrawRadialGradient(context, gradient, relativeCenter, CGFloat(circleDiameter/2.2), relativeCenter, CGFloat(self.frame.width/1.7), CGGradientDrawingOptions(kCGGradientDrawsAfterEndLocation))
        
        self.layer.cornerRadius = frame.height/2
    }
}
