//
//  ActivityData.swift
//  RepHub
//
//  Created by Garrett Head on 9/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import UIKit

enum ActivityName : String {
    case mind = "Mind"
    case exercise = "Exercise"
    case eat = "Eat"
    case hydrate = "Hydrate"
}


enum Activity {
    case mind(MindActivity)
    case exercise(ExerciseActivity)
    case eat(EatActivity)
    case hydrate(HydrateActivity)
    
    var label : String {
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
    
    var icon : UIImage {
        switch self {
        case .mind(let mind):
            return mind.icon
        case .exercise(let exercise):
             return exercise.icon
        case .eat(let eat):
            return eat.icon
        case .hydrate(let hydrate):
            return hydrate.icon
        }
    }
    
    var color : UIColor {
        switch self {
        case .mind(let mind):
            return mind.color
        case .exercise(let exercise):
             return exercise.color
        case .eat(let eat):
            return eat.color
        case .hydrate(let hydrate):
            return hydrate.color
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
    
    
    
    var data : [(String,Double, String)]? {
        switch self {
            case .mind(let mind):
                return mind.data
            case .exercise(let exercise):
                return exercise.data
            case .eat(let eat):
                return eat.data
            case .hydrate(let hydrate):
                return hydrate.data
        }
    }
    
    var percentComplete : Double? {
        switch self {
            case .mind(let mind):
                return mind.dailyTotal / mind.target * 100
            case .exercise(let exercise):
                return exercise.dailyTotal! / exercise.target * 100
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


extension Activity {


}








