//
//  ActivityData.swift
//  RepHub
//
//  Created by Garrett Head on 9/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


struct ActivityData {
    var label : String
    var dailyTotal : Double
    var target : Double
    var unit : String?
    var icon : UIImage
    var color : UIColor
    var percentComplete : Double? {
        return dailyTotal / target * 100
    }
    
    init(label: String, dailyTotal : Double, target: Double, icon: UIImage, color: UIColor){
        self.label = label
        self.dailyTotal = dailyTotal
        self.target = target
        self.icon = icon
        self.color = color
        
    }
    init(label: String, dailyTotal : Double, target: Double, icon: UIImage, color: UIColor, unit: String) {
        self.label = label
        self.dailyTotal = dailyTotal
        self.target = target
        self.icon = icon
        self.color = color
        self.unit = unit
    }
    
    init(activity: Activity){
        switch activity {
            case .mind(let mind):
                self.label = mind.label
                self.dailyTotal = mind.dailyTotal
                self.target = mind.target
                self.icon = mind.icon
                self.color = mind.color
            case .exercise(let exercise):
                self.label = exercise.label
                self.dailyTotal = exercise.dailyTotal
                self.target = exercise.target
                self.icon = exercise.icon
                self.color = exercise.color
            case .eat(let eat):
                self.label = eat.label
                self.dailyTotal = eat.dailyTotal
                self.target = eat.target
                self.icon = eat.icon
                self.color = eat.color
            case .hydrate(let hydrate):
                self.label = hydrate.label
                self.dailyTotal = hydrate.dailyTotal
                self.target = hydrate.target
                self.icon = hydrate.icon
                self.color = hydrate.color
        }
        
        
    }
}


enum Activity {
    case mind(MindActivityData)
    case exercise(ExerciseActivityData)
    case eat(EatActivityData)
    case hydrate(HydrateActivityData)
}


struct MindActivityData {
    var label : String = "Mind"
    var dailyTotal : Double
    var target : Double
    var unit : String = "minute"
    var engUnit : UnitDuration = .minutes
    var icon : UIImage = UIImage(named: "Mind")!
    var color : UIColor = UIColor.Theme.lavender
    var percentComplete : Double? {
        return self.dailyTotal / self.target * 100
    }
    
    init(dailyTotal: Double, target : Double){
        self.dailyTotal = dailyTotal
        self.target = target
    }
}



struct ExerciseActivityData {
    var label : String = "Exercise"
    var dailyTotal : Double
    var target : Double
    var unit : String = "Calories"
    var engUnit : UnitEnergy = .calories
    var icon : UIImage = UIImage(named: "Exercise")!
    var color : UIColor = UIColor.Theme.salmon
    var percentComplete : Double? {
        return self.dailyTotal / self.target * 100
    }
    
    init(dailyTotal: Double, target : Double){
        self.dailyTotal = dailyTotal
        self.target = target
    }
    
}

struct EatActivityData {
    var label : String = "Eat"
    var dailyTotal : Double
    var target : Double
    var unit : String = "Calories"
    var engUnit : UnitEnergy = .calories
    var icon : UIImage = UIImage(named: "Eat")!
    var color : UIColor = UIColor.Theme.seaFoam
    var percentComplete : Double? {
        return self.dailyTotal / self.target * 100
    }
    
    init(dailyTotal: Double, target : Double){
        self.dailyTotal = dailyTotal
        self.target = target
    }
    
}

struct HydrateActivityData {
    var label : String = "Hydrate"
    var dailyTotal : Double
    var target : Double
    var unit : String = "oz"
    var engUnit : UnitVolume = .fluidOunces
    var icon : UIImage = UIImage(named: "Hydrate")!
    var color : UIColor = UIColor.Theme.aqua
    var percentComplete : Double? {
        return self.dailyTotal / self.target * 100
    }
    
    init(dailyTotal: Double, target : Double){
        self.dailyTotal = dailyTotal
        self.target = target
    }
    
}




