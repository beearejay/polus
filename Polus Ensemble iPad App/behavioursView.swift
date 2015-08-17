//
//  behaviourView.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 7/05/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class BehavioursView: UIView {
    
    var id = 0 {
        didSet{
            self.backgroundColor = behaviourColourArray[id%2]
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.layer.zPosition = 10
        self.layer.cornerRadius = frame.height / 2
    }
    
    required init(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
}