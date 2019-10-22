//
//  HydrateActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

class HydrateActivity : Activity {
    var label: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    var dailyTotal: Double?
    var target: Double
    var percentComplete: Double?
    var percentRemaining: Double?
    var data: [(String, Double, String)] = []
    
    // MARK: - HealthKit properties
    var totalWaterDrank : Double?
    var totalCaffeine : Double?
    var totalSugar : Double?
    
    init() {
        self.label = "Hydrate"
        self.icon = UIImage.Theme.Activity.hydrate
        self.color = UIColor.Theme.Activity.hydrate
        self.unit = "Ounces"
        self.target = 64.0
        self.getHKSamples()
       
    }
}

extension HydrateActivity {
    
    private func calculateProgress(){
        let dailyTotal = self.dailyTotal ?? 0.0
        self.percentComplete = dailyTotal / self.target * 100
        self.percentRemaining = 100.0 - self.percentComplete!
    }
    
    
    private func getHKSamples(){
        
        // Water Drank
        HydrateActivityStore.getTodaysWaterDrank(){
           result, error in
            guard let result = result else {
               if let error = error {
                   print(error)
               }
               return
            }
            self.totalWaterDrank = result
            self.dailyTotal = result
            self.data.append(("Water", result, "oz"))
            self.calculateProgress()
        }

        // Caffeine
        HydrateActivityStore.getTodaysCaffeine(){
           result, error in
           guard let result = result else {
               if let error = error {
                   print(error)
               }
               return
           }
           self.totalCaffeine = result
            self.data.append(("Caffeine", result, HKUnit.gramUnit(with: .milli).unitString))
        }

        // Sugar
        HydrateActivityStore.getTodaysSugar(){
           result, error in
           guard let result = result else {
               if let error = error {
                   print(error)
               }
               return
           }
           self.totalSugar = result
            self.data.append(("Sugar", result, HKUnit.gram().unitString))
        }

    }
}
