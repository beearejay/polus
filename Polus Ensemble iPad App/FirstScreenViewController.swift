//
//  FirstScreenViewController.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 11/08/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {
    
    var ip: String = ""
    var port: Int = 0
    var delegate: ParseIpAndPort?
    var mainScreenController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundMainColour
        self.navigationController!.navigationBarHidden = false
        delegate?.updatePort(port)
        delegate?.updateIp(ip)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func connectButton() {
        delegate?.updateIp(ipAddressField.text)
        delegate?.updatePort(portField.text.toInt()!)
    }
    
    @IBOutlet weak var ipAddressField: UITextField!
    @IBOutlet weak var portField: UITextField!
}
