//
//  NutritionCalculator.swift
//  RepHub
//
//  Created by Garrett Head on 3/31/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import Foundation

struct NutritionCalculator {

    var totalizer : [String : Double] = [:]
    
    func total(foodType: String) -> Bool {
        return !foodType.isEmpty
    }

    func food(foodType: String) -> Bool {
        return foodType != "Drinks"
    }

    func drink(foodType: String) -> Bool {
        return foodType == "Drinks"
    }
    
    func filterLogs(closure: (String) -> Bool, logs : [NutritionLog]) -> [NutritionLog]{
        var filteredLogs = [NutritionLog]()
        for log in logs {
            if let food = log.food {
                if let group = food.foodGroup {
                    if closure(group) {
                        filteredLogs.append(log)
                    }
                }
            }
        }
        print(filteredLogs)
        return filteredLogs
    }
    

    func totalizeNutrition(logs : [NutritionLog]) -> [String:Double]{
        var nutrition = [Nutrient]()
        var totalizer = [String:Double]()
        for log in logs {
            if let nutritionList = log.nutrition {
                nutrition.append(contentsOf: nutritionList)
            }
        }
        let keys = Set<String>(nutrition.filter({!$0.name!.isEmpty}).map{$0.name!})
        for key in keys {
            let sum = nutrition.filter({$0.name == key}).map({$0.value!}).reduce(0, +)
            totalizer[key] = sum
        }
        return totalizer

    }
    
    func calculateTotalWaterDrank(logs : [NutritionLog]) -> Double {
        var total = 0.0
        for log in logs {
            if let food = log.food, let type = food.category{
                if let serving = log.householdServingSize, type == "Water" {
                    total += serving
                }
            }
        }
        return total
    }
    
    func calculateTotalFluidsDrank(logs: [NutritionLog]) -> Double {
        var total = 0.0
        for log in logs {
            if let serving = log.householdServingSize {
                total += serving
            }
        }
        
        return total
    }
}


// MARK: Hydration Activity extension
extension NutritionCalculator {
    
    // calculate hydration rolling total
    func calculateHydrationRunningTotal(logs: [NutritionLog])  -> [Double]{
        var totalHydration = [Double]()
        var sum = 0.0
        let calendar = Calendar.current
        for hour in 0...24 {
            var components = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
            components.hour = hour
            if let startTime = calendar.date(from: components)?.timeIntervalSince1970 {
                components.hour = hour + 1
                if let endTime = calendar.date(from: components)?.timeIntervalSince1970 {
                    let logsOnTheHour = logs.filter({
                        $0.timestamp! >= Double(startTime) && $0.timestamp! <= Double(endTime)
                    })
                    for log in logsOnTheHour {
                        if let food = log.food, let type = food.category{
                            if let serving = log.householdServingSize, type == "Water" {
                                sum += serving
                            }
                        }
                    }
                    
                }
            }
            totalHydration.append(sum)
        }
        
        return totalHydration
    }
    
    // calculate drinks by type
    func calculateTotalDrankByType(logs: [NutritionLog]) -> [String:Double]{
        var drinksByType = [String:Double]()
        let uniqueDrinkTypes = logs.reduce([], {
            $0.contains($1.food?.category) ? $0 : $0 + [$1.food?.category]
        })
        for key in uniqueDrinkTypes {
            let sum = logs.filter({$0.food?.category == key}).map({$0.servingSize!}).reduce(0, +)
            drinksByType[key!] = sum
        }
        return drinksByType
    }
    
}


// MARK: Nutrition Activity extension
extension NutritionCalculator {
    
    // calculate macro ratio
    func calculateMacroRatio(logs: [NutritionLog]) -> [Double] {
        return []
    }
    
    // calculate nutrition rolling total
    func calculateCaloriesConsumedRunningTotal(logs: [NutritionLog])  -> [Double]{
        var totalNutrition = [Double]()
        var sum = 0.0
        let calendar = Calendar.current
        for hour in 0...24 {
            var components = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
            components.hour = hour
            if let startTime = calendar.date(from: components)?.timeIntervalSince1970 {
                components.hour = hour + 1
                if let endTime = calendar.date(from: components)?.timeIntervalSince1970 {
                    let logsOnTheHour = logs.filter({
                        $0.timestamp! >= Double(startTime) && $0.timestamp! <= Double(endTime)
                    })
                    for log in logsOnTheHour {
                        if let nutrition = log.nutrition {
                            let energy = nutrition.filter({ $0.name == Nutrients.Energy.rawValue}).first
                            if let calories = energy!.value {
                                sum += calories
                            }
                            
                        }
                    }
                    
                }
            }
            totalNutrition.append(sum)
        }
        
        return totalNutrition
    }
}

