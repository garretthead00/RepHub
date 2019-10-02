//
//  ExerciseActivity.swift
//  RepHub
//
//  Created by Garrett Head on 9/26/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


struct ExerciseActivity {
    var dailyTotal : Double
    var target : Double
    var unit : String = "Calories"
    var engUnit : UnitEnergy = .calories
    var logs : [Double]?
    var work : Double? = 0.0

    
    // MARK: - HealthKit properties
    var workoutsCompleted : Double? = 0.0
    var standMinutes : Double? = 0.0
    var flightsAscended : Double? = 0.0
    var exerciseMinutes : Double? = 0.0
 
    var totalActiveCalories : Double? = 0.0
    var totalRestingCalories : Double? = 0.0
    var totalCaloriesBurned : Double? = 0.0
    var distance : Double? = 0.0
    
    
    
    var totalSteps : Double? {
        var steps = 0.0
        print("--fetching steps!! \(steps)")
        ExerciseActivityStore.getTodaysSteps(completion: {
            results in
            if let totalSteps = results {
                print("--got them steps boi!! \(totalSteps)")
                steps = totalSteps
            }
        })
        print("--returning steps: \(steps)")
        return steps
    }
    
    
    
    lazy var dailyActivities : [(String,Double,String)]? = {
        print("dailyActivities set with steps \(self.totalSteps)")

        return [
//            ("Steps",self.totalSteps!,"steps")
//            ("Workouts Completed", self.workoutsCompleted!,"workouts"),
//            ("Exercise Minutes",self.exerciseMinutes!,"minutes"),
//            ("Stand Minutes",self.standMinutes!,"minutes"),
//            ("Steps",self.totalSteps!,"steps"),
//            ("Distance",self.distance!,"mi"),
//            ("Flights Ascended",self.flightsAscended!,"flights"),
//            ("Active Calories",self.totalActiveCalories!,"calories"),
//            ("Resting Calories",self.totalRestingCalories!,"calories"),
//            ("Total Calories",self.totalCaloriesBurned!,"calories"),
            ]
    }()
    
    
    // MARK: - Initializers
    init(logs : [Double]) {
        print("ExerciseActivity init")
        self.target = 730.0
        self.logs = logs
        self.dailyTotal = logs.reduce(0, +)
    }
}


