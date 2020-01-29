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
    
    
    
    var name: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    var dailyTotal: Double?
    var target: Double?
    var remainingToTarget : Double?
    var percentComplete: Double?
    var percentRemaining: Double?
    
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
        self.name = "Exercise"
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
            self.remainingToTarget = self.target! - dailyTotal
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
        
        }
    }
    
    
}
