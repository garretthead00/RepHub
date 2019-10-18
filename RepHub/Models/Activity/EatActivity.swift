//
//  EatActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

class EatActivity : Activity {
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
    var totalEnergyConsumed : Double?
    var totalProtein : Double?
    var totalFat : Double?
    var totalCarbohydrates : Double?
    
    
    init() {
        self.label = "Eat"
        self.icon = UIImage.Theme.Activity.eat
        self.color = UIColor.Theme.Activity.eat
        self.unit = "Calories"
        self.dailyTotal = 0.0
        self.target = 1600.0
        self.percentComplete = self.dailyTotal / self.target * 100
        self.percentRemaining = 100.0 - self.percentComplete
        self.getHKSamples()
        //EatActivityStore.getHourlyEnergyConsumedTotal()
    }
}

extension EatActivity {
    
    private func getHKSamples(){
        // Energy Consumed
        EatActivityStore.getTodaysEnergyConsumed(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.totalEnergyConsumed = result
            self.dailyTotal = result
        }
        
        // Protein
        EatActivityStore.getTodaysProteinConsumed(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.totalProtein = result
            self.data.append(("Protein", result, HKUnit.gram().unitString))
        }
        
        // Fat
        EatActivityStore.getTodaysFatConsumed(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.totalFat = result
            self.data.append(("Fat", result, HKUnit.gram().unitString))
        }
        
        // Carbohydrates
        EatActivityStore.getTodaysCarbohydratesConsumed(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.totalCarbohydrates = result
            self.data.append(("Carbs", result, HKUnit.gram().unitString))
        }
    }
}