//
//  distanceCalculations.swift
//  Polus Ensemble iPad App
//
//  Created by Blake Johnston II on 23/06/15.
//  Copyright (c) 2015 beearejay. All rights reserved.
//

import Foundation

class DistanceCalculations {
    
    var oscHandler = OSCHandler()
    
    func setup(){
        
        oscHandler.setup()
        oscHandler.sendOSC("Initial", index: 20)
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
}