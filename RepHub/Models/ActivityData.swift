//
//  ActivityData.swift
//  RepHub
//
//  Created by Garrett Head on 9/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


enum ActivityName : String {
    case mind = "Mind"
    case exercise = "Exercise"
    case eat = "Eat"
    case hydrate = "Hydrate"
}

struct MindActivityData {
    var dailyTotal : Double
    var target : Double
    var unit : String = "minute"
    var engUnit : UnitDuration = .minutes
    var logs : [Double]?
    
    // MARK: - HealthKit Properties
    var mindfulMinutes : Double? = 0.0
    
    
    var dailyActivities : [(String,Double,String)]? {
        return nil
    }
    
    // MARK: - Initializers
    init(logs : [Double]) {
        self.target = 30.0
        self.logs = logs
        self.dailyTotal = logs.reduce(0, +)
    }
}



struct EatActivityData {
    var dailyTotal : Double
    var target : Double
    var unit : String = "Calories"
    var engUnit : UnitEnergy = .calories
    var logs : [Double]?
    
    
    var dailyActivities : [(String,Double,String)]? {
        return nil
    }
    
    // MARK: - Initializers
    init(logs : [Double]) {
        self.target = 2000.0
        self.logs = logs
        self.dailyTotal = logs.reduce(0, +)
    }
}

struct HydrateActivityData {
    var dailyTotal : Double
    var target : Double
    var unit : String = "oz"
    var engUnit : UnitVolume = .fluidOunces
    var logs : [Double]?
    
    // MARK: - HealthKit Properties
    var waterDrank : Double? = 0.0
    var totalSugar : Double? = 0.0
    var totalCaffeine : Double? = 0.0
    var totalCaloriesConsumed : Double? = 0.0
    
    
    var dailyActivities : [(String,Double,String)]? {
        return nil
    }
    
    
    // MARK: - Initializers
    init(logs : [Double]) {
        self.target = 64.0
        self.logs = logs
        self.dailyTotal = logs.reduce(0, +)
    }
}

enum Activity {
    case mind(MindActivityData)
    case exercise(ExerciseActivity)
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
    
    var logs : [Double]? {
        switch self {
            case .mind(let mind):
                return mind.logs
            case .exercise(let exercise):
                 return exercise.logs
            case .eat(let eat):
                return eat.logs
            case .hydrate(let hydrate):
                return hydrate.logs
        }
    }
    
    var dailyTotal : Double? {
        switch self {
            case .mind(let mind):
                return mind.dailyTotal
            case .exercise(let exercise):
                 return exercise.dailyTotal
            case .eat(let eat):
                return eat.dailyTotal
            case .hydrate(let hydrate):
                return hydrate.dailyTotal
        }
    }
    
    var target : Double? {
        switch self {
            case .mind(let mind):
                return mind.target
            case .exercise(let exercise):
                 return exercise.target
            case .eat(let eat):
                return eat.target
            case .hydrate(let hydrate):
                return hydrate.target
        }
    }
    
    var unit : String? {
        switch self {
            case .mind(let mind):
                return mind.unit
            case .exercise(let exercise):
                 return exercise.unit
            case .eat(let eat):
                return eat.unit
            case .hydrate(let hydrate):
                return hydrate.unit
        }
    }
    
    var dailyActivities : [(String,Double,String)]? {
        switch self {
            case .mind(let mind):
                return mind.dailyActivities
            case .exercise(var exercise):
                 return exercise.dailyActivities
            case .eat(let eat):
                return eat.dailyActivities
            case .hydrate(let hydrate):
                return hydrate.dailyActivities
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








