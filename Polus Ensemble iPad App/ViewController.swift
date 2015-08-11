//
//  ViewController.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 7/05/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import UIKit

let numberOfInstruments = 6
let numberOfBehaviours = 4
let numberOfRelations = numberOfInstruments*numberOfBehaviours
var circleDiameter:CGFloat = 150
var instrumentSize:CGFloat = 100

public var positionsOfBehavioursViews: [(Double,Double)] = []
public var positionsOfInstrumentViews: [(Double,Double)] = []
public var distanceVectors = [Double](count: numberOfRelations, repeatedValue: 0.0)

var instrumentViewArray:[InstrumentView] = []
var behavioursViewArray:[BehavioursView] = []
var behaviourOrbitViewArray:[BehaviourOrbitView] = []
var behaviourOrbitSizeArray: [Double] = []
var orbitPercentageInsideAndStatus: [(Double, Bool)] = []
var originalBehaviourPosition: [(CGFloat, CGFloat)] = []
var originalInstrumentPosition: [(CGFloat, CGFloat)] = []

//Colour Pallatte
let instrumentColoutArray: [UIColor] =
[   UIColor(red: 43/255.0, green: 150/255.0, blue: 176/255.0, alpha: 1),
    UIColor(red: 43/255.0, green: 150/255.0, blue: 176/255.0, alpha: 1),
    UIColor(red: 43/255.0, green: 150/255.0, blue: 176/255.0, alpha: 1),
    UIColor(red: 43/255.0, green: 150/255.0, blue: 176/255.0, alpha: 1),
    UIColor(red: 43/255.0, green: 150/255.0, blue: 176/255.0, alpha: 1),
    UIColor(red: 43/255.0, green: 150/255.0, blue: 176/255.0, alpha: 1)]

let behaviourColourArray: [UIColor] =
[   UIColor(red: 170/255.0, green: 56/255.0, blue: 69/255.0, alpha: 1),
    UIColor(red: 210/255.0, green: 99/255.0, blue: 89/255.0, alpha: 1),
    UIColor(red: 110/255.0, green: 103/255.0, blue: 90/255.0, alpha: 1),
    UIColor(red: 203/255.0, green: 191/255.0, blue: 171/255.0, alpha: 1),
    UIColor(red: 170/255.0, green: 56/255.0, blue: 69/255.0, alpha: 1),
    UIColor(red: 210/255.0, green: 99/255.0, blue: 89/255.0, alpha: 1),
    UIColor(red: 110/255.0, green: 103/255.0, blue: 90/255.0, alpha: 1),
    UIColor(red: 203/255.0, green: 191/255.0, blue: 171/255.0, alpha: 1)]

let behaviourOrbitColourArray: [UIColor] =
[
    UIColor(red: 210/255.0, green: 99/255.0, blue: 89/255.0, alpha: 1),
    UIColor(red: 210/255.0, green: 99/255.0, blue: 89/255.0, alpha: 0.2),
    UIColor(red: 203/255.0, green: 191/255.0, blue: 171/255.0, alpha: 1),
    UIColor(red: 203/255.0, green: 191/255.0, blue: 171/255.0, alpha: 0.2),
    UIColor(red: 210/255.0, green: 99/255.0, blue: 89/255.0, alpha: 1),
    UIColor(red: 210/255.0, green: 99/255.0, blue: 89/255.0, alpha: 0.2),
    UIColor(red: 203/255.0, green: 191/255.0, blue: 171/255.0, alpha: 1),
    UIColor(red: 203/255.0, green: 191/255.0, blue: 171/255.0, alpha: 0.2)]

let backgroundMainColour = UIColor(red: 241/255.0, green: 238/255.0, blue: 229/255.0, alpha: 1)
let behaviourColour = UIColor(red: 255/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1)
let bahaviourBackgroundColour = UIColor(red: 255/255.0, green: 240/255.0, blue: 165/255.0, alpha: 1)
let utilityColour = UIColor(red: 182/255.0, green: 73/255.0, blue: 38/255.0, alpha: 1)


class ViewController: UIViewController {
    
    var calculate = DistanceCalculations()
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var reset = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundMainColour
        
        //Set reset
        setUpResetButton()
        //Set frame size
        width = UIScreen.mainScreen().bounds.width
        height = UIScreen.mainScreen().bounds.height
        
        calculate.setup()
        initialiseBehaviours()
        initialiseOrbits()
        initialiseInstruments()
        for index in 0...(numberOfRelations-1){
            orbitPercentageInsideAndStatus.append(0.0, false)
        }
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
        calculate.updatePositionsOfViews()
        calculate.calculateDistanceVectors()
        calculate.calculateOrbitOverlapsWithInstruments()
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
        calculate.updatePositionsOfViews()
        calculate.calculateDistanceVectors()
        calculate.calculateOrbitOverlapsWithInstruments()
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
            calculate.updateSizeOfOrbits()
            calculate.calculateOrbitOverlapsWithInstruments()
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
            calculate.updateSizeOfOrbits()
            calculate.calculateOrbitOverlapsWithInstruments()
        }
    }
    
    func handleBehaviourHold(recognizer: UILongPressGestureRecognizer){
        var localBehaviour = recognizer.view as! BehavioursView
        var localOrbit = behaviourOrbitViewArray[localBehaviour.id]
        
        localOrbit.frame.size.width = circleDiameter*1.8
        localOrbit.frame.size.height = circleDiameter*1.8
        localOrbit.center = localBehaviour.center
        localOrbit.setNeedsDisplay()
        calculate.updateSizeOfOrbits()
        calculate.calculateOrbitOverlapsWithInstruments()
        calculate.calculateOrbitOverlapsWithInstruments()
    }
    
    func resetButtonTouch(sender: UIButton!) {
        for behaviourView in behavioursViewArray{
            var localOrbit = behaviourOrbitViewArray[behaviourView.id]
            UIView.animateWithDuration(1.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                behaviourView.center.x = originalBehaviourPosition[behaviourView.id].0
                behaviourView.center.y = originalBehaviourPosition[behaviourView.id].1
                localOrbit.frame.size.width = circleDiameter*1.8
                localOrbit.frame.size.height = circleDiameter*1.8
                localOrbit.center = behaviourView.center
                self.updateDisplayOfViews()
                }, completion:{
                    finished in
                    self.updateDisplayOfViews()
                    println("Complete")
                }
            )
        }
        
        for instrumentView in instrumentViewArray{
            UIView.animateWithDuration(1.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            instrumentView.center.x = originalInstrumentPosition[instrumentView.id].0
            instrumentView.center.y = originalInstrumentPosition[instrumentView.id].1
                }, completion: nil)
        }
        
        calculate.updatePositionsOfViews()
        calculate.calculateDistanceVectors()
        calculate.calculateOrbitOverlapsWithInstruments()
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
}

