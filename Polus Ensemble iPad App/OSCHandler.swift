//
//  OSCHandler.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 23/06/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import Foundation

class OSCHandler{
    
    var newManager = OSCManager()
    var newOutPort = OSCOutPort()
    
    func setup(){
        newOutPort = newManager.createNewOutputToAddress("127.0.0.1", atPort: 12000)
    }
    
    func sendOSC(id: String, distance: Float, index: Int32){
        let newMsg: OSCMessage = OSCMessage(address: id)
        newMsg.addInt(index)
        newMsg.addFloat(distance)
        println("Sending On or Up id Tag is = \(id)" + "index is: \(index)")
        newOutPort.sendThisMessage(newMsg)
    }
    
    func sendOSC(id: String, index: Int32){
        let newMsg: OSCMessage = OSCMessage(address: id)
        newMsg.addInt(index)
        newOutPort.sendThisMessage(newMsg)
        println("Sending Off")
    }
}