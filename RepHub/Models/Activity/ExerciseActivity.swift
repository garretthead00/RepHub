//
//  ExerciseActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

class ExerciseActivity : Activity {
    var label: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    var dailyTotal: Double
    var target: Double
    var percentComplete: Double
    var percentRemaining: Double
    var data: [(String, Double, String)] = []
    
     // MARK: - HealthKit properties
    var workoutsCompleted : Double?
    var flightsAscended : Double?
    var exerciseMinutes : Double?
    var totalActiveCalories : Double?
    var totalRestingCalories : Double?
    var distance : Double?
    var totalCaloriesBurned : Double?
    var standMinutes : Double?
    var totalSteps : Double?
    
    init() {
        self.label = "Exercise"
        self.icon = UIImage.Theme.Activity.exercise
        self.color = UIColor.Theme.Activity.exercise
        self.unit = "Calories"
        self.dailyTotal = 367.0
        self.target = 630.0
        self.percentComplete = self.dailyTotal / self.target * 100
        self.percentRemaining = 100.0 - self.percentComplete
        self.getHKSamples()
    }
}


// MARK: - HealthKit data
extension ExerciseActivity {
    
    private func getHKSamples(){
        // steps
        ExerciseActivityStore.getTodaysSteps(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.totalSteps = result
            self.data.append(("Steps", result, "steps"))
        }
        
        //stand minutes
        ExerciseActivityStore.getTodaysStandHours(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.standMinutes = result
            self.data.append(("Stand", result, "minutes"))
        }
        
        // active calories burned
        ExerciseActivityStore.getTodaysActiveEnergyBurned(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.totalActiveCalories = result
            self.data.append(("Active Calories", result, "Calories"))
        }
    }
}
