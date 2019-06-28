//
//  NutritionStore.swift
//  
//
//  Created by Garrett Head on 6/15/19.
//

import HealthKit


var nutritionDataTypeCollection : [String:HKQuantityType] = [
    "Calcium":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCalcium)!,
    "Carbohydrate":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!,
    "Cholesterol":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCholesterol)!,
    "Energy":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!,
    "Fiber":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFiber)!,
    "Folate":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFolate)!,
    "Iron":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryIron)!,
    "Monounsaturated Fat":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatMonounsaturated)!,
    "Polyunsaturated Fat":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatPolyunsaturated)!,
    "Potassium":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryPotassium)!,
    "Protein":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!,
    "Saturated Fat":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatSaturated)!,
    "Sodium":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySodium)!,
    "Sugars":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar)!,
    "Thiamin":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryThiamin)!,
    "Vitamin A":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminA)!,
    "Vitamin C":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminC)!,
    "Vitamin D":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryVitaminD)!,
    "Water":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!,
    "Caffeine":HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!
]

var nutritionUnitCollection : [String:HKUnit] = [
    "g" : HKUnit(from: .gram),
    "mcg" : HKUnit.gramUnit(with: .micro),
    "kcal" : HKUnit(from: .kilocalorie),
    "mg" : HKUnit.gramUnit(with: .milli)
]


class NutritionStore {
    
    /**
        SAVING DATA
    **/
    class func saveDrink(nutrients: [Nutrient]) {
        let healthStore = HKHealthStore()
        var samples : [HKSample] = []
        for nutrient in nutrients {
            if let name = nutrient.name, let sampleType = nutritionDataTypeCollection[name] {
                let unit = nutritionUnitCollection[nutrient.unit!]
                let quantity = HKQuantity(unit: unit!, doubleValue: Double(nutrient.value!))
                let sample = HKQuantitySample(type: sampleType, quantity: quantity, start: NSDate() as Date, end: Date())
                samples.append(sample)
            }
        }
        healthStore.save(samples, withCompletion: { (success, error) -> Void in
            if success {
                ProgressHUD.showSuccess("Saved to HealthKit!")
            } else {
                ProgressHUD.showError("Could not save to HealthKit!")
            }
        })
    }
    
    
    /**
        FETCHING DATA
     **/
    class func fetchHydrationLogs(completion: @escaping ([HKQuantitySample]?, Error?) -> Swift.Void) {
        let healthStore = HKHealthStore()
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater) else {
            print("*** Unable to create a dietaryWater type ***")
            fatalError("*** Unable to create a dietaryWater type ***")
            
        }
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let todayAtMidnight = cal.startOfDay(for: date)
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: todayAtMidnight, end: date, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = Int(HKObjectQueryNoLimit)
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            guard let samples = results as? [HKQuantitySample] else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
            }
            DispatchQueue.main.async {
                completion(samples, nil)
            }
        }
        healthStore.execute(sampleQuery)
    }
}

