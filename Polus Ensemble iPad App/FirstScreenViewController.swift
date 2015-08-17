//
//  FirstScreenViewController.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 11/08/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {
    
    var ip: String = "169.254.211.53"
    var port: Int = 12000
    var delegate: ParseIpAndPort?
    var mainScreenController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundMainColour
        //self.navigationController!.navigationBarHidden = false
        delegate?.updatePort(port)
        delegate?.updateIp(ip)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.navigationController!.navigationBarHidden = true
        delegate?.updatePort(portField.text.toInt()!)
        delegate?.updateIp(ipAddressField.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var ipAddressField: UITextField!
    @IBOutlet weak var portField: UITextField!
}
