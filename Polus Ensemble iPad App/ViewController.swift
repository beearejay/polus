//
//  ViewController.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 7/05/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import UIKit

//Colour Pallatte
let instrumentColour: UIColor = UIColor(red: 43/255.0, green: 150/255.0, blue: 176/255.0, alpha: 1)
let behaviourColourArray: [UIColor] = [
    UIColor(red: 170/255.0, green: 56/255.0, blue: 69/255.0, alpha: 1),
    UIColor(red: 110/255.0, green: 103/255.0, blue: 90/255.0, alpha: 1)]
let behaviourOrbitColourArray: [UIColor] = [
    UIColor(red: 210/255.0, green: 99/255.0, blue: 89/255.0, alpha: 1),
    UIColor(red: 210/255.0, green: 99/255.0, blue: 89/255.0, alpha: 0.2),
    UIColor(red: 203/255.0, green: 191/255.0, blue: 171/255.0, alpha: 1),
    UIColor(red: 203/255.0, green: 191/255.0, blue: 171/255.0, alpha: 0.2)]
let backgroundMainColour = UIColor(red: 241/255.0, green: 238/255.0, blue: 229/255.0, alpha: 1)

protocol ParseIpAndPort {
    func updateIp(ip: String)
    func updatePort(port: Int)
}

class ViewController: UIViewController, ParseIpAndPort {
    
    var numberOfInstruments = 6
    var numberOfBehaviours = 2
    var circleDiameter:CGFloat = 150
    var instrumentSize:CGFloat = 100
    
    var instrumentViewArray:[InstrumentView] = []
    var behavioursViewArray:[BehavioursView] = []
    var behaviourOrbitViewArray:[BehaviourOrbitView] = []
    var positionsOfBehavioursViews: [(Double,Double)] = []
    var positionsOfInstrumentViews: [(Double,Double)] = []
    var behaviourOrbitSizeArray: [Double] = []
    var orbitPercentageInsideAndStatus: [(Double, Bool)] = []
    var originalBehaviourPosition: [(CGFloat, CGFloat)] = []
    var originalInstrumentPosition: [(CGFloat, CGFloat)] = []
    var distanceVectors: [Double] = []
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    var reset = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var config = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    
    var oscHandler = OSCHandler()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = backgroundMainColour
        let numberOfRelations = numberOfInstruments*numberOfBehaviours
        width = UIScreen.mainScreen().bounds.width
        height = UIScreen.mainScreen().bounds.height
        distanceVectors = [Double](count: numberOfRelations, repeatedValue: 0.0)
        for index in 0...(numberOfRelations-1){orbitPercentageInsideAndStatus.append(0.0, false)}
        //Set reset
        setUpResetButton()
        setUpConfigButton()
        initialiseBehaviours()
        initialiseOrbits()
        initialiseInstruments()
        oscHandler.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpResetButton(){
        reset.frame = CGRectMake(16, 28, 68, 35)
        reset.backgroundColor = UIColor(red: 43/255.0, green: 150/255.0, blue: 176/255.0, alpha: 1)
        reset.layer.cornerRadius = 5.0
        reset.layer.masksToBounds = true
        reset.setTitle("Reset", forState: UIControlState.Normal)
        reset.titleLabel!.font = UIFont(name: "Avenir", size: 22)
        reset.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        reset.addTarget(self, action: "resetButtonTouch:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(reset)
    }
    
    func setUpConfigButton(){
        config.frame = CGRectMake(self.view.frame.width - 84, 28, 68, 35)
        config.backgroundColor = UIColor(red: 43/255.0, green: 150/255.0, blue: 176/255.0, alpha: 1)
        config.layer.cornerRadius = 5.0
        config.layer.masksToBounds = true
        config.setTitle("Config", forState: UIControlState.Normal)
        config.titleLabel!.font = UIFont(name: "Avenir", size: 22)
        config.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        config.addTarget(self, action: "prepareSegueToConfig:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(config)
    }
    
    func updateIp(ip: String){
        oscHandler.ip = ip
    }
    
    func updatePort(port: Int){
        oscHandler.port = Int32(port)
    }
    
    func initialiseInstruments(){
    
        var a:CGFloat = width/2 - 50
        var b:CGFloat = height/3
        var rv:CGFloat = height/3.5
        var rh:CGFloat = width/2.3
        var t:Double = 0.5 //The spread
        
        for index in 0...(numberOfInstruments-1){
            
            //Positioning for Landscape
            var g = CGFloat(index) * CGFloat(t) + 3.48
            var d = CGFloat(cos(g))
            var e = CGFloat(sin(g))
            var x:CGFloat = a + (rh*d)
            var y:CGFloat = b + (rv*e)
            let newInstrumentView = InstrumentView(frame: CGRectMake(x, y, instrumentSize, instrumentSize))
            originalInstrumentPosition.append(CGFloat(x) + (instrumentSize/2),CGFloat(y) + (instrumentSize/2))
            newInstrumentView.id = index
            view.addSubview(newInstrumentView)
            let panRecognizer = UIPanGestureRecognizer(target: self, action: "handleInstrumentPan:")
            newInstrumentView.addGestureRecognizer(panRecognizer)
            instrumentViewArray.append(newInstrumentView)
            positionsOfInstrumentViews.append(Double(x), Double(y))
        }
    }
    
    func initialiseBehaviours(){
        for index in 0...(numberOfBehaviours-1){
            //Positioning
            var x:CGFloat = (width / 4) * CGFloat(index) + 50.0
            var y:CGFloat =  height - (circleDiameter*1.4)
            originalBehaviourPosition.append(CGFloat(x) + (circleDiameter/2),CGFloat(y) + (circleDiameter/2))
            let newBehavioursView = BehavioursView(frame: CGRectMake(x, y, circleDiameter, circleDiameter))
            newBehavioursView.id = index
            behavioursViewArray.append(newBehavioursView)
            view.addSubview(newBehavioursView)
    
            let panRecognizer = UIPanGestureRecognizer(target: self, action: "handleBehaviourPan:")
            newBehavioursView.addGestureRecognizer(panRecognizer)
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "handleBehaviourPinch:")
            newBehavioursView.addGestureRecognizer(pinchRecognizer)
            let holdRecognizer = UILongPressGestureRecognizer(target: self, action: "handleBehaviourHold:")
            newBehavioursView.addGestureRecognizer(holdRecognizer)
            positionsOfBehavioursViews.append(Double(x), Double(y))
        }
    }
    
    func initialiseOrbits(){
        for behaviourView in behavioursViewArray{
            let newOrbitView = BehaviourOrbitView(frame: CGRectMake(0, 0, behaviourView.frame.width * 1.8, behaviourView.frame.height * 1.8))
            newOrbitView.id = behaviourView.id
            behaviourOrbitSizeArray.append(Double(behaviourView.frame.width))
            newOrbitView.center = behaviourView.center
            newOrbitView.innerCircleDiameter = circleDiameter
            behaviourOrbitViewArray.append(newOrbitView)
            view.insertSubview(newOrbitView, atIndex: behavioursViewArray.count-2)
        }
    }
    

    func handleInstrumentPan(recognizer: UIPanGestureRecognizer)
    {
        var translation = recognizer.translationInView(self.view)
        if let view = recognizer.view{
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        updatePositionsOfViews()
        calculateDistanceVectors()
        calculateOrbitOverlapsWithInstruments()
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func handleBehaviourPan(recognizer: UIPanGestureRecognizer){
        var translation = recognizer.translationInView(self.view)
        var localBehaviour  = recognizer.view as! BehavioursView
        var localOrbit = behaviourOrbitViewArray[localBehaviour.id]
        
        localBehaviour.center = CGPoint(x: localBehaviour.center.x + translation.x, y: localBehaviour.center.y + translation.y)
        localOrbit.center = CGPoint(x: localOrbit.center.x + translation.x, y: localOrbit.center.y + translation.y)
        self.view.bringSubviewToFront(localBehaviour)
        self.view.bringSubviewToFront(reset)
        updatePositionsOfViews()
        calculateDistanceVectors()
        calculateOrbitOverlapsWithInstruments()
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func handleBehaviourPinch(recognizer: UIPinchGestureRecognizer){
        var localBehaviour  = recognizer.view as! BehavioursView
        var localOrbit = behaviourOrbitViewArray[localBehaviour.id]
        if (localOrbit.frame.width < self.width * 0.7) //Control to see if the circle is very large
        {
            var newWidth = localOrbit.frame.width*recognizer.scale
            var newHeight = localOrbit.frame.height*recognizer.scale
            localOrbit.frame.size.width = newWidth
            localOrbit.frame.size.height = newHeight
            localOrbit.center = localBehaviour.center
            localOrbit.drawRect(localBehaviour.frame)
            recognizer.scale = 1
            localOrbit.setNeedsDisplay()
            updateSizeOfOrbits()
            calculateOrbitOverlapsWithInstruments()
        }
        else if (recognizer.scale <= 1.0){ //For at limits of size, but pinching in.
            var newWidth = localOrbit.frame.width*recognizer.scale
            var newHeight = localOrbit.frame.height*recognizer.scale
            localOrbit.frame.size.width = newWidth
            localOrbit.frame.size.height = newHeight
            localOrbit.center = localBehaviour.center
            localOrbit.drawRect(localBehaviour.frame)
            recognizer.scale = 1
            localOrbit.setNeedsDisplay()
            updateSizeOfOrbits()
            calculateOrbitOverlapsWithInstruments()
        }
    }
    
    func handleBehaviourHold(recognizer: UILongPressGestureRecognizer){
        var localBehaviour = recognizer.view as! BehavioursView
        var localOrbit = behaviourOrbitViewArray[localBehaviour.id]
        
        localOrbit.frame.size.width = circleDiameter*1.8
        localOrbit.frame.size.height = circleDiameter*1.8
        localOrbit.center = localBehaviour.center
        localOrbit.setNeedsDisplay()
        updateSizeOfOrbits()
        calculateOrbitOverlapsWithInstruments()
    }
    
    func resetButtonTouch(sender: UIButton!) {
        for behaviourView in behavioursViewArray{
            var localOrbit = behaviourOrbitViewArray[behaviourView.id]
            UIView.animateWithDuration(1.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                behaviourView.center.x = self.originalBehaviourPosition[behaviourView.id].0
                behaviourView.center.y = self.originalBehaviourPosition[behaviourView.id].1
                localOrbit.frame.size.width = self.circleDiameter*1.8
                localOrbit.frame.size.height = self.circleDiameter*1.8
                localOrbit.center = behaviourView.center
                self.updateDisplayOfViews()
                }, completion:{
                    finished in
                    self.updateDisplayOfViews()
                }
            )
        }
        
        for instrumentView in instrumentViewArray{
            UIView.animateWithDuration(1.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            instrumentView.center.x = self.originalInstrumentPosition[instrumentView.id].0
            instrumentView.center.y = self.originalInstrumentPosition[instrumentView.id].1
                }, completion: nil)
        }
        
        updatePositionsOfViews()
        updateSizeOfOrbits()
        calculateDistanceVectors()
        calculateOrbitOverlapsWithInstruments()
    }
    
    func prepareSegueToConfig(sender: UIButton!) {
        self.performSegueWithIdentifier("configSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "configSegue"{
         let configController = segue.destinationViewController as! FirstScreenViewController
            configController.delegate = self
        }
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
    }
    
    func calculateOrbitOverlapsWithInstruments(){
        for var behaviourIndex = 0; behaviourIndex < positionsOfBehavioursViews.count; ++behaviourIndex{
            for var instrumentIndex = 0; instrumentIndex < positionsOfInstrumentViews.count; ++instrumentIndex{
                var index = instrumentIndex + (behaviourIndex * positionsOfInstrumentViews.count)
                var size = behaviourOrbitSizeArray[behaviourIndex]
                var distance = distanceVectors[index]
                if(size > distance){
                    var percentage = distance/size
                    orbitPercentageInsideAndStatus[index].0 = distance/size
                    if(orbitPercentageInsideAndStatus[index].1 == false) //if its the first time in
                    {
                        oscHandler.sendOSC("NoteOn", distance: Float(percentage), index: Int32(index))
                        orbitPercentageInsideAndStatus[index].1 = true
                    }
                    else //updater
                    {
                        oscHandler.sendOSC("NoteUpdate", distance: Float(percentage), index: Int32(index))
                    }
                }
                else if(orbitPercentageInsideAndStatus[index].1 == true) //if we've just left
                {
                    oscHandler.sendOSC("NoteOff", index: Int32(index))
                    orbitPercentageInsideAndStatus[index].1 = false
                }
            }
        }
    }
    
    func updateDisplayOfViews(){
        for behaviourView in behavioursViewArray{
            var localOrbit = behaviourOrbitViewArray[behaviourView.id]
            behaviourView.setNeedsDisplay()
            localOrbit.setNeedsDisplay()
        }
        
        for instrumentView in instrumentViewArray{
            instrumentView.setNeedsDisplay()
        }
    }
    
    func updatePositionsOfViews(){
        //enumerate here
        for instrumentView in instrumentViewArray{
            positionsOfInstrumentViews[instrumentView.id] = (Double(instrumentView.center.x), Double(instrumentView.center.y))
            
        }
        
        for behaviourView in behavioursViewArray{
            positionsOfBehavioursViews[behaviourView.id] = (Double(behaviourView.center.x), Double(behaviourView.center.y))
        }
    }
    
    func calculateDistanceVectors(){
        for var behaviourIndex = 0; behaviourIndex < positionsOfBehavioursViews.count; ++behaviourIndex{
            for var instrumentIndex = 0; instrumentIndex < positionsOfInstrumentViews.count; ++instrumentIndex{
                var behaviourPosition = positionsOfBehavioursViews[behaviourIndex]
                var instumentPosition = positionsOfInstrumentViews[instrumentIndex]
                var a = behaviourPosition.0 - instumentPosition.0
                var b = behaviourPosition.1 - instumentPosition.1
                var c = sqrt((a*a) + (b*b))
                distanceVectors[instrumentIndex + (behaviourIndex * positionsOfInstrumentViews.count)] = c
            }
        }
    }
    
    func updateSizeOfOrbits(){
        for BehaviourOrbitView in behaviourOrbitViewArray{
            behaviourOrbitSizeArray[BehaviourOrbitView.id] = Double(BehaviourOrbitView.frame.width) / 2.0
        }
    }
}

