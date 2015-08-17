//
//  instrumentView.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 7/05/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import UIKit

@IBDesignable
class InstrumentView: UIView {
    
    var idLabel: UILabel = UILabel()
    
    var id = 0 {
        didSet {
            self.layer.backgroundColor = instrumentColour.CGColor
         idLabel.text = String(id + 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.zPosition = 0
        self.layer.masksToBounds = true
        idLabel.frame = CGRectMake(self.frame.width - 11, self.frame.height - 14, 12, 12)
        idLabel.backgroundColor = UIColor.clearColor()
        idLabel.font = UIFont(name: "Avenir", size: 10)
        idLabel.textColor = UIColor.whiteColor()
        self.addSubview(idLabel)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
