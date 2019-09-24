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
    var activityType : Activity?
    var percentComplete : Double? {
        return dailyTotal / target * 100
    }
    var percentRemaining : Double? {
        if let complete = self.percentComplete {
            let remaining = 100 - complete
            return remaining <= 0.0 ? 0.0 : remaining
        }
        return 0.0
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
                self.activityType = activity
            case .exercise(let exercise):
                self.label = exercise.label
                self.dailyTotal = exercise.dailyTotal
                self.target = exercise.target
                self.icon = exercise.icon
                self.color = exercise.color
                self.activityType = activity
            case .eat(let eat):
                self.label = eat.label
                self.dailyTotal = eat.dailyTotal
                self.target = eat.target
                self.icon = eat.icon
                self.color = eat.color
                self.activityType = activity
            case .hydrate(let hydrate):
                self.label = hydrate.label
                self.dailyTotal = hydrate.dailyTotal
                self.target = hydrate.target
                self.icon = hydrate.icon
                self.color = hydrate.color
                self.activityType = activity
        }
        
        
    }
}

enum ActivityName : String {
    case mind = "Mind"
    case exercise = "Exercise"
    case eat = "Eat"
    case hydrate = "Hydrate"
}



enum Activity {
    case mind(MindActivityData)
    case exercise(ExerciseActivityData)
    case eat(EatActivityData)
    case hydrate(HydrateActivityData)
    
    var label : String? {
        switch self {
        case .mind( _):
            return ActivityName.mind.rawValue
        case .exercise( _):
            return ActivityName.exercise.rawValue
        case .eat( _):
            return ActivityName.eat.rawValue
        case .hydrate( _):
            return ActivityName.hydrate.rawValue
        }
    }
    
    var icon : UIImage? {
        switch self {
        case .mind( _):
            return UIImage(named: ActivityName.mind.rawValue)
        case .exercise( _):
            return UIImage(named: ActivityName.exercise.rawValue)
        case .eat( _):
            return UIImage(named: ActivityName.eat.rawValue)
        case .hydrate( _):
            return UIImage(named: ActivityName.hydrate.rawValue)
        }
    }
    
    var color : UIColor? {
        switch self {
        case .mind( _):
            return UIColor.Theme.Activity.mind
        case .exercise( _):
            return UIColor.Theme.Activity.exercise
        case .eat( _):
            return UIColor.Theme.Activity.eat
        case .hydrate( _):
            return UIColor.Theme.Activity.hydrate
        }
    }
    
    var percentComplete : Double? {
        switch self {
            case .mind(let mind):
                return mind.dailyTotal / mind.target * 100
            case .exercise(let exercise):
                 return exercise.dailyTotal / exercise.target * 100
            case .eat(let eat):
                return eat.dailyTotal / eat.target * 100
            case .hydrate(let hydrate):
                return hydrate.dailyTotal / hydrate.target * 100
        }
    }
    
    
    var percentRemaining : Double? {
        switch self {
            case .mind( _):
                if let complete = self.percentComplete {
                    let remaining = 100 - complete
                    return remaining <= 0.0 ? 0.0 : remaining
                } else {
                    return 0.0
                }
            case .exercise( _):
                 if let complete = self.percentComplete {
                     let remaining = 100 - complete
                     return remaining <= 0.0 ? 0.0 : remaining
                 } else {
                     return 0.0
                 }
            case .eat( _):
                if let complete = self.percentComplete {
                    let remaining = 100 - complete
                    return remaining <= 0.0 ? 0.0 : remaining
                } else {
                    return 0.0
                }
            case .hydrate( _):
                if let complete = self.percentComplete {
                    let remaining = 100 - complete
                    return remaining <= 0.0 ? 0.0 : remaining
                } else {
                    return 0.0
                }
        }
    }
}


struct MindActivityData {
    var label : String = "Mind"
    var dailyTotal : Double
    var target : Double
    var unit : String = "minute"
    var engUnit : UnitDuration = .minutes
    var icon : UIImage = UIImage(named: "Mind")!
    var color : UIColor = UIColor.Theme.lavender

    
    init(dailyTotal: Double, target : Double){
        self.dailyTotal = dailyTotal
        self.target = target
        self.logs = []
    }
    
    var logs : [Double]?
    init(logs : [Double]) {
        self.target = 30.0
        self.logs = logs
        self.dailyTotal = logs.reduce(0, +)
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
    
    init(dailyTotal: Double, target : Double){
        self.dailyTotal = dailyTotal
        self.target = target
        self.logs = []
    }
    
    var logs : [Double]?
    init(logs : [Double]) {
        self.target = 730.0
        self.logs = logs
        self.dailyTotal = logs.reduce(0, +)
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

    
    init(dailyTotal: Double, target : Double){
        self.dailyTotal = dailyTotal
        self.target = target
        self.logs = []
    }
    
    var logs : [Double]?
    init(logs : [Double]) {
        self.target = 2000.0
        self.logs = logs
        self.dailyTotal = logs.reduce(0, +)
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

    
    init(dailyTotal: Double, target : Double){
        self.dailyTotal = dailyTotal
        self.target = target
        self.logs = []
    }
    
    var logs : [Double]?
    init(logs : [Double]) {
        self.target = 64.0
        self.logs = logs
        self.dailyTotal = logs.reduce(0, +)
    }
    
}




