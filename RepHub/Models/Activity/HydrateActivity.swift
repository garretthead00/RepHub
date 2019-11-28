//
//  HydrateActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

struct HydrateActivity : Activity {
    var label: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    var dailyTotal: Double?
    var target: Double
    var percentComplete: Double?
    var percentRemaining: Double?
    var data: [(String, Double, String)] = []
    
    
    var logs : [HydrateLog]? {
        didSet {
            self.calculateProgress()
        }
    }
    
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
        self.dailyTotal = 0.0
        
        // calculated totals
        self.totalWaterDrank = 0.0
        self.totalCaffeine = 0.0
        self.totalSugar = 0.0
        
        self.data.append(("Water", self.totalWaterDrank!, HKUnit.fluidOunceUS().unitString))
        self.data.append(("Caffeine", self.totalCaffeine!, HKUnit.gramUnit(with: .milli).unitString))
        self.data.append(("Sugar", self.totalSugar!, HKUnit.gram().unitString))
       
    }
}

extension HydrateActivity {
    
    init(logs: [Double]){
        self.label = "Hydrate"
        self.icon = UIImage.Theme.Activity.hydrate
        self.color = UIColor.Theme.Activity.hydrate
        self.unit = "Ounces"
        self.target = 64.0
        
        self.dailyTotal = logs.reduce(0, +)
        self.percentComplete = self.dailyTotal! / self.target * 100
        self.percentRemaining = 100.0 - self.percentComplete!
        
        // calculated totals
        self.totalWaterDrank = 0.0
        self.totalCaffeine = 0.0
        self.totalSugar = 0.0
        self.data.append(("Water", self.totalWaterDrank!, HKUnit.fluidOunceUS().unitString))
        self.data.append(("Caffeine", self.totalCaffeine!, HKUnit.gramUnit(with: .milli).unitString))
        self.data.append(("Sugar", self.totalSugar!, HKUnit.gram().unitString))
    }
    
    mutating func calculateProgress(logs: [HydrateLog]){
        self.dailyTotal = logs.map({$0.servingSize!}).reduce(0, +)
        self.percentComplete = self.dailyTotal! / self.target * 100
        self.percentRemaining = 100.0 - self.percentComplete!
        print("dailyTotal: \(self.dailyTotal) percentComplete: \(self.percentComplete)")
    }
    
    private mutating func calculateProgress(){
//        print("water calculateProgress!")
//        let dailyTotal = self.dailyTotal ?? 0.0
//        self.percentComplete = dailyTotal / self.target * 100
//        self.percentRemaining = 100.0 - self.percentComplete!
        self.dailyTotal = self.logs!.filter({$0.drinkType == "Water"}).map({$0.servingSize!}).reduce(0, +)
        self.percentComplete = self.dailyTotal! / self.target * 100
        self.percentRemaining = 100.0 - self.percentComplete!
        print("dailyTotal: \(self.dailyTotal!) percentComplete: \(self.percentComplete!)")
    }
    
    
//    private func getHKSamples(){
//
//        // Water Drank
//        HydrateActivityStore.getTodaysWaterDrank(){
//           result, error in
//            guard let result = result else {
//               if let error = error {
//                   print(error)
//               }
//               return
//            }
//            print("water drank! \(result)")
//            self.totalWaterDrank = result
//            self.dailyTotal = result
//            self.data.append(("Water", result, HKUnit.fluidOunceUS().unitString))
//            //self.calculateProgress()
//        }
//
//        // Caffeine
//        HydrateActivityStore.getTodaysCaffeine(){
//           result, error in
//           guard let result = result else {
//               if let error = error {
//                   print(error)
//               }
//               return
//           }
//           self.totalCaffeine = result
//            self.data.append(("Caffeine", result, HKUnit.gramUnit(with: .milli).unitString))
//        }
//
//        // Sugar
//        HydrateActivityStore.getTodaysSugar(){
//           result, error in
//           guard let result = result else {
//               if let error = error {
//                   print(error)
//               }
//               return
//           }
//           self.totalSugar = result
//            self.data.append(("Sugar", result, HKUnit.gram().unitString))
//        }
//
//    }
}
