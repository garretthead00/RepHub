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


class NutritionStore {
    

    class func saveDrink(drink: Drink, nutrients: [Nutrient]) {
        let healthStore = HKHealthStore()
        var samples : [HKQuantitySample] = []
        for nutrient in nutrients {
            print("nutrientName: \(nutrient.name)")
            
            if let name = nutrient.name, let sampleType = nutritionDataTypeCollection[name] {
                print("yep! nutrientName: \(nutrient.name)")
                var unit : HKUnit?
                if name == "Energy" {
                    unit = HKUnit(from: .kilocalorie)
                } else {
                    unit = HKUnit(from: .gram)
                }
                let quantity = HKQuantity(unit: unit!, doubleValue: Double(nutrient.value!))
                let sample = HKQuantitySample(type: sampleType, quantity: quantity, start: NSDate() as Date, end: Date())
                healthStore.save(sample, withCompletion: { (success, error) -> Void in
                    if success {
                        // handle success
                        ProgressHUD.showSuccess("Water saved to HealthKit")
                    } else {
                        // handle error
                        ProgressHUD.showError("Water NOT saved to HealthKit")
                    }
                })
            }
        }

        
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
    
    
    /**
        SAVING DATA
     **/
    class func save(value: Int, completion: @escaping ((Bool, Error?) -> Void)) {
        let healthStore = HKHealthStore()
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater) else {
            print("*** Unable to create a dietaryWater type ***")
            fatalError("*** Unable to create a dietaryWater type ***")
            
        }
        let quantity = HKQuantity(unit: HKUnit.fluidOunceUS(), doubleValue: Double(value))
        let sample = HKQuantitySample(type: sampleType, quantity: quantity, start: NSDate() as Date, end: Date())
        healthStore.save(sample, withCompletion: { (success, error) -> Void in
            if success {
                // handle success
                ProgressHUD.showSuccess("Water saved to HealthKit")
            } else {
                // handle error
                ProgressHUD.showError("Water NOT saved to HealthKit")
            }
        })
    }
    
    class func saveCoffeeSample(value: Int, completion: @escaping ((Bool, Error?) -> Void)) {
        let healthStore = HKHealthStore()
        guard let waterSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater) else {
            print("*** Unable to create a dietaryWater type ***")
            fatalError("*** Unable to create a dietaryWater type ***")
            
        }
        guard let coffeeSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) else {
            print("*** Unable to create a dietaryWater type ***")
            fatalError("*** Unable to create a dietaryWater type ***")
            
        }
        let caffeineContent = 11.875 * Double(value)
        let waterQuantity = HKQuantity(unit: HKUnit.fluidOunceUS(), doubleValue: Double(value))
        let caffeineQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: caffeineContent)
        let waterSample = HKQuantitySample(type: waterSampleType, quantity: waterQuantity, start: NSDate() as Date, end: Date())
        let coffeeSample = HKQuantitySample(type: coffeeSampleType, quantity: caffeineQuantity, start: NSDate() as Date, end: Date())
        
        healthStore.save(waterSample, withCompletion: { (success, error) -> Void in
            if success {
                healthStore.save(coffeeSample, withCompletion: { (success, error) -> Void in
                    if success {
                        // handle success
                        ProgressHUD.showSuccess("Coffee saved to HealthKit")
                    } else {
                        // handle error
                        ProgressHUD.showError("Coffee NOT saved to HealthKit")
                    }
                })
            } else {
                // handle error
                ProgressHUD.showError("Coffee NOT saved to HealthKit")
            }
        })
        

    }
    
    class func saveTeaSample(value: Int, completion: @escaping ((Bool, Error?) -> Void)) {
        let healthStore = HKHealthStore()
        guard let waterSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater) else {
            print("*** Unable to create a dietaryWater type ***")
            fatalError("*** Unable to create a dietaryWater type ***")
            
        }
        guard let teaSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) else {
            print("*** Unable to create a dietaryWater type ***")
            fatalError("*** Unable to create a dietaryWater type ***")
            
        }
        let caffeineContent = 3.25 * Double(value)
        let waterQuantity = HKQuantity(unit: HKUnit.fluidOunceUS(), doubleValue: Double(value))
        let caffeineQuantity = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: caffeineContent)
        let waterSample = HKQuantitySample(type: waterSampleType, quantity: waterQuantity, start: NSDate() as Date, end: Date())
        let teaSample = HKQuantitySample(type: teaSampleType, quantity: caffeineQuantity, start: NSDate() as Date, end: Date())
        
        healthStore.save(waterSample, withCompletion: { (success, error) -> Void in
            if success {
                healthStore.save(teaSample, withCompletion: { (success, error) -> Void in
                    if success {
                        // handle success
                        ProgressHUD.showSuccess("Tea saved to HealthKit")
                    } else {
                        // handle error
                        ProgressHUD.showError("Tea NOT saved to HealthKit")
                    }
                })
            } else {
                // handle error
                ProgressHUD.showError("Tea NOT saved to HealthKit")
            }
        })
        
        
    }
    
    

    
}

