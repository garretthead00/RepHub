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
    var dailyTotal: Double?
    var target: Double?
    var percentComplete: Double?
    var percentRemaining: Double?
    var data: [(String, Double, String)] = []
    var summaryData: [(String, Double, String)] = []
    
    // MARK: - HealthKit properties
    var workoutsCompleted : Double?
    var flightsAscended : Double?
    var exerciseMinutes : Double?
    var totalActiveCaloriesBurned : Double?
    var totalRestingCaloriesBurned : Double?
    var distance : Double?
    var totalCaloriesBurned : Double?
    var standMinutes : Double?
    var totalSteps : Double?
    
    
    init() {
        self.label = "Exercise"
        self.icon = UIImage.Theme.Activity.exercise
        self.color = UIColor.Theme.Activity.exercise
        self.unit = "Calories"
        self.target = 630.0
        self.queryHKActiveEnergyBurned()
        self.queryHKExerciseMinutes()
        self.queryHKTotalSteps()
        self.queryHKStandMinutes()
        self.queryHKDistance()
        self.queryHKRestingEnergy()
        self.queryHKFlightsClimbed()
        
        
    }
    
   
}


// MARK: - HealthKit data
extension ExerciseActivity {
    
    
    private func calculateProgress() {
        if let dailyTotal = self.dailyTotal {
            self.percentComplete = dailyTotal / self.target! * 100
            self.percentRemaining = 100.0 - self.percentComplete!
        }

    }
    
    func queryHKActiveEnergyBurned(){
        // active calories burned
        print("query active energy burned")
        ExerciseActivityStore.getTodaysActiveEnergyBurned(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            print("got active energy burned \(result)")
            self.totalActiveCaloriesBurned = result
            self.dailyTotal = result.truncate(places: 2)
            self.calculateProgress()
        }
    }
    
    func queryHKExerciseMinutes(){
        // exercise minutes
        print("query exercise minutes")
        ExerciseActivityStore.getTodaysExerciseMinutes(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            print("got exercise minutes \(result)")
            self.exerciseMinutes = result
            self.summaryData.append(("Exercise", result, HKUnit.minute().unitString))
            self.data.append(("Exercise", result, HKUnit.minute().unitString))
            
            
        }
    }
    func queryHKTotalSteps(){
        // steps
        print("query total steps")
        ExerciseActivityStore.getTodaysSteps(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            print("got total steps \(result)")
            self.totalSteps = result
            self.summaryData.append(("Steps", result, ""))
            self.data.append(("Steps", result, ""))
        }
    }
    func queryHKStandMinutes(){
        //stand minutes
        print("query stand minutes")
        ExerciseActivityStore.getTodaysStandMinutes(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            print("got stand minutes \(result)")
            self.standMinutes = result
            self.summaryData.append(("Stand", result, HKUnit.minute().unitString))
            self.data.append(("Stand", result, HKUnit.minute().unitString))
        }
    }
    
    func queryHKDistance(){
        ExerciseActivityStore.getTodaysDistance(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.distance = result
            
            self.data.append(("Distance", result, HKUnit.mile().unitString))
        }
    }

    func queryHKFlightsClimbed(){
        ExerciseActivityStore.getTodaysFlightsClimbed(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.flightsAscended = result
            self.data.append(("Flights Climbed", result, ""))
        }
    }

    func queryHKRestingEnergy(){
        ExerciseActivityStore.getTodaysRestingEnergyBurned(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.totalRestingCaloriesBurned = result
            self.data.append(("Resting Energy", result, HKUnit.largeCalorie().unitString))
        }
    }
    
    
}
