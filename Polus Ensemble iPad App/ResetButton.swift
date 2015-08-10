//
//  ResetButton.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 7/08/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import UIKit

@IBDesignable
class resetButton: UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.zPosition = 0
        self.layer.masksToBounds = true
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}