//
//  WorkoutInterval.swift
//  RepHub
//
//  Created by Garrett Head on 9/30/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//
// WorkoutIntervals describe a particular section of time during a workout where vents occured.

import HealthKit

struct WorkoutInterval {
    
    var start: Date
    var end: Date
    var steps: Int?
    var distance: Double?
    
    var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }
    
    var totalEnergyBurned: Double {
        let caloriesPerHour: Double = 450
        let hours: Double = duration/3600
        let totalCalories = caloriesPerHour*hours
        return totalCalories
//    var heartRate : Int
    
    
    }

}
