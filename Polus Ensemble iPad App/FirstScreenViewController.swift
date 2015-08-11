//
//  FirstScreenViewController.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 11/08/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundMainColour
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func connectButton() {
        self.performSegueWithIdentifier("segueToMainScreen", sender: nil)
    }
}
