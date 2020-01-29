//
//  EatActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit


struct EatActivity : Activity {
    var name: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    
    var dailyTotal: Double?
    var remainingToTarget: Double?
    var target: Double?
    var percentComplete: Double?
    var percentRemaining: Double?

    var logs : [FoodLog] = []
    // var nutritionLogs : [[NutritionLog]] = []
    
    
    // MARK: Nutrition
    lazy var totalEnergyConsumed : Double = {
        return 432.0
    }()
    lazy var protein : Double = {
        return 0.0
    }()
    lazy var fats : Double = {
        return 0.0
    }()
    lazy var carbohydrates : Double = {
        return 0.0
    }()

    
}

extension EatActivity {
    
    init(){
        self.name = "Nutrition"
        self.icon = UIImage.Theme.Activity.eat
        self.color = UIColor.Theme.Activity.eat
        self.unit = "Calories"
        self.target = 1600.0
        self.dailyTotal = 432.0
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
    }
    
    init(logs: [FoodLog]){
        self.name = "Nutrition"
        self.icon = UIImage.Theme.Activity.eat
        self.color = UIColor.Theme.Activity.eat
        self.unit = "Calories"
        self.target = 1600.0
        self.dailyTotal = 432.0
        self.remainingToTarget = (self.target! - self.dailyTotal!) < 0.0 ? 0.0 : (self.target! - self.dailyTotal!)
    }

    
//    private func getFoodLogs(){
//        guard let currentUser = API.RepHubUser.CURRENT_USER else {
//            return
//        }
//        let currentUserId = currentUser.uid
//
//        API.UserFoodLog.observeFoodLogs(withId: currentUserId, completion: {
//            log in
//            self.logs.append(log)
//            if self.logs.count > 0 {
//                self.logs = self.logs.sorted(by: { $0.timestamp! > $1.timestamp!})
//            }
//            //print("food log -- : \(log.servingSize) \(log.servingSizeUnit) @ \(log.timestamp)")
//            self.calculateProgress()
//        })
//    }
//
//    private func nutritionTotalizer(forNutrient nutrient: String) -> Double{
//        var sum = 0.0
//        // iterate through the logs and sum the values on the nutrient map.
//        return sum
//    }
    
}
