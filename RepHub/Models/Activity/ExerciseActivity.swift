//
//  ExerciseActivity.swift
//  RepHub
//
//  Created by Garrett Head on 9/26/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


class ExerciseActivity {
    var dailyTotal : Double?
    var target : Double = 0.0
    var unit : String = "Calories"
    var engUnit : UnitEnergy = .calories
    var work : Double? = 0.0
    var icon : UIImage = UIImage.Theme.Activity.exercise
    var color : UIColor = UIColor.Theme.Activity.exercise

    
    // MARK: - HealthKit properties
    var workoutsCompleted : Double? = 0.0

    var flightsAscended : Double? = 0.0
    var exerciseMinutes : Double? = 0.0
    var totalActiveCalories : Double? = 0.0
    var totalRestingCalories : Double? = 0.0
    var distance : Double? = 0.0
    
    var totalCaloriesBurned : Double? {
        didSet {
            self.updateData()
        }
    }
    var standMinutes : Double? {
        didSet {
            self.updateData()
        }
    }
    var totalSteps : Double? {
        didSet {
            self.updateData()
        }
    }
    
    
    var data : [(String,Double, String)] = []
    
    init() {
        print("ExerciseActivity init")
        self.target = 730.0
        self.dailyTotal = 0.0
        self.getHealthKitData()
   }
    

}

    // MARK: - Initializers
extension ExerciseActivity {

    private func getHealthKitData(){
        
        // Steps
        HealthKit_ExerciseService().fetchTodaysSteps(completion: {
            result in
            if result > 0 {
                self.totalSteps = result
                print("self.totalSteps \(self.totalSteps)")
            }

        })
        
        // Stand Hours
        HealthKit_ExerciseService().fetchTodaysStandHours(completion: {
            result in
            if result > 0 {
                self.standMinutes = result
                print("self.standMinutes \(self.standMinutes)")
            }

        })
        
        // Active Energy Burned
        HealthKit_ExerciseService().fetchTodaysActiveEnergyBurned(completion: {
            result in
            if result > 0 {
                self.totalCaloriesBurned = result
                print("self.totalCaloriesBurned \(self.totalCaloriesBurned)")
            }

        })
    }
    
    private func updateData(){
        self.data = []
        
        if let steps = self.totalSteps, steps > 0.0 {
            self.data.append(("Steps",steps,""))
        }
    }
}


