//
//  HydrateActivity.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

struct HydrationActivity: Activity {
    var name: String
    var icon: UIImage
    var color: UIColor
    var unit: String
    var dailyTotal: Double?
    var remainingToTarget: Double?
    var target: Double?
    var percentComplete: Double?
    var percentRemaining: Double?
    var summaryData: [(String, Double, String)]?
    var logs : [NutritionLog]? {
        didSet {
            refreshActivity()
        }
    }
    var hydrationLogs : [NutritionLog]?
    
    // MARK: Calculator
    var calculator : NutritionCalculator?
    var totalNutrition : [String : Double]?     // total nutrition (food + drinks)
    var nutrition : [String : Double]?      // nutrition filtered for drinks only.
    
    // MARK: Nutrition Groups
    var macros : [(String, Double, Double, String)]?
    var electrolytes: [(String, Double, Double, String)]?
    var otherNutrients : [(String, Double, Double, String)]?
    
    // calculated propeties
    var rollingTotal : [Double]?
    var drinksByType : [String:Double]?

    var totalWater : Double?
    var totalFluids : Double?
    
    init(){
        name = "Hydration"
        icon = UIImage.Theme.Activity.hydrate
        color = UIColor.Theme.Activity.hydrate
        unit = "fl oz"
        target = 64.0
        calculator = NutritionCalculator()
        totalFluids = 0.0
        totalWater = 0.0
        dailyTotal = 0.0
        remainingToTarget = 0.0
        percentComplete = 0.0
        percentRemaining = 0.0
        totalNutrition = [String:Double]()
        nutrition = [String:Double]()
        summaryData = []
        macros = []
        electrolytes = []
        otherNutrients = []
        
        rollingTotal = []
        drinksByType = [String:Double]()
        hydrationLogs = []
    }
    
}

extension HydrationActivity {
    
    private mutating func refreshActivity(){
        // filter the logs beforehand so that they can be used for the calculations.
        hydrationLogs = calculator!.filterLogs(closure: calculator!.drink, logs: logs!)
        totalNutrition = calculator!.totalizeNutrition(logs: logs!)
        nutrition = calculator!.totalizeNutrition(logs: hydrationLogs!)
        totalWater = calculator!.calculateTotalWaterDrank(logs: hydrationLogs!)
        totalFluids = calculator!.calculateTotalFluidsDrank(logs: hydrationLogs!)
        rollingTotal = calculator!.calculateHydrationRunningTotal(logs: hydrationLogs!)
        drinksByType = calculator!.calculateTotalDrankByType(logs: hydrationLogs!)
        dailyTotal = totalWater ?? 0.0
        remainingToTarget = (target! - dailyTotal!) < 0.0 ? 0.0 : (target! - dailyTotal!)
        percentComplete = (target! > 0) ? (dailyTotal! / target!) * 100 : 0.0
        percentRemaining = (100 - percentComplete!) > 0 ? (100 - percentComplete!) : 0.0
        
        summaryData = [
            (Nutrients.Caffeine.rawValue, totalNutrition![Nutrients.Caffeine.rawValue] ?? 0.0, "mg"),
            (Nutrients.Sugar.rawValue, totalNutrition![Nutrients.Sugar.rawValue] ?? 0.0, "g"),
            (Nutrients.Fluids.rawValue, totalFluids!, "oz")
        ]
        
        macros = [
            (Nutrients.Protein.rawValue,totalNutrition![Nutrients.Protein.rawValue] ?? 0.0,nutrition![Nutrients.Protein.rawValue] ?? 0.0, "g"),
            (Nutrients.Carbs.rawValue,totalNutrition![Nutrients.Carbs.rawValue] ?? 0.0,nutrition![Nutrients.Carbs.rawValue] ?? 0.0, "g"),
            (Nutrients.Fat.rawValue,totalNutrition![Nutrients.Fat.rawValue] ?? 0.0,nutrition![Nutrients.Fat.rawValue] ?? 0.0, "g"),
        ]
                
        electrolytes = [
            (Nutrients.Calcium.rawValue, totalNutrition![Nutrients.Calcium.rawValue] ?? 0.0,nutrition![Nutrients.Calcium.rawValue] ?? 0.0, "mg"),
            (Nutrients.Chloride.rawValue, totalNutrition![Nutrients.Chloride.rawValue] ?? 0.0,nutrition![Nutrients.Chloride.rawValue] ?? 0.0, "mg"),
            (Nutrients.Magnesium.rawValue, totalNutrition![Nutrients.Magnesium.rawValue] ?? 0.0,nutrition![Nutrients.Magnesium.rawValue] ?? 0.0, "mg"),
            (Nutrients.Phosphorus.rawValue, totalNutrition![Nutrients.Phosphorus.rawValue] ?? 0.0, nutrition![Nutrients.Phosphorus.rawValue] ?? 0.0, "mg"),
            (Nutrients.Potassium.rawValue, totalNutrition![Nutrients.Potassium.rawValue] ?? 0.0, nutrition![Nutrients.Potassium.rawValue] ?? 0.0, "mg"),
            (Nutrients.Sodium.rawValue, totalNutrition![Nutrients.Sodium.rawValue] ?? 0.0,nutrition![Nutrients.Sodium.rawValue] ?? 0.0, "mg"),
        ]
            
        otherNutrients = [
            (Nutrients.Caffeine.rawValue, totalNutrition![Nutrients.Caffeine.rawValue] ?? 0.0, nutrition![Nutrients.Caffeine.rawValue] ?? 0.0, "mg"),
            ("alcohol", 0.0, 0.0, "oz")
        ]
        
        
    }
    

}
