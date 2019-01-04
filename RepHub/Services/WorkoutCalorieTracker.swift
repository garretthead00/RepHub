//
//  WorkoutCalorieTracker.swift
//  RepHub
//
//  Created by Garrett Head on 11/21/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation

struct WorkoutCalorieTracker {
    
    var caloriesPerHour: Double = 450
    
     func totalEnergyBurned(startTime: Date) -> Double {
        let hours: Double = Date().timeIntervalSince(startTime)/3600
        let totalCalories = caloriesPerHour * hours
        return totalCalories
        
    }
    
    func getTotalEnergyBurned(duration: Double) -> Double {
        let caloriesPerHour: Double = 450
        let hours: Double = duration/3600
        let totalCalories = caloriesPerHour*hours
        return totalCalories
        //    var heartRate : Int
        
        
    }
    
}
