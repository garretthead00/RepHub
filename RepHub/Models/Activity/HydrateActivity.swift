//
//  HydrateActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class HydrateActivity : Activity {
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
    var totalWaterDrank : Double?
    var totalCaffeine : Double?
    var totalSugar : Double?
    
    init() {
        self.label = "Hydrate"
        self.icon = UIImage.Theme.Activity.hydrate
        self.color = UIColor.Theme.Activity.hydrate
        self.unit = "Ounces"
        self.dailyTotal = 46.0
        self.target = 64.0
        self.percentComplete = self.dailyTotal / self.target * 100
        self.percentRemaining = 100.0 - self.percentComplete
        self.getHKSamples()
    }
}

extension HydrateActivity {
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
           self.data.append(("Water", result, "fl oz"))
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
           self.data.append(("Caffeine", result, "mg"))
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
           self.data.append(("Sugar", result, "g"))
        }

    }
}
