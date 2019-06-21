//
//  HealthKitSetupAssistant.swift
//  RepHub
//
//  Created by Garrett Head on 9/21/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitSetupAssistant {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeNutritionData(completion: @escaping (Bool, Error?) -> Void) {
        // Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        guard let calcium = HKObjectType.quantityType(forIdentifier: .dietaryCalcium),
            let carbohydrate = HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates),
            let cholesterol = HKObjectType.quantityType(forIdentifier: .dietaryCholesterol),
            let energy = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed),
            let fiber = HKObjectType.quantityType(forIdentifier: .dietaryFiber),
            let folate = HKObjectType.quantityType(forIdentifier: .dietaryFolate),
            let iron = HKObjectType.quantityType(forIdentifier: .dietaryIron),
            let monounsaturatedFat = HKObjectType.quantityType(forIdentifier: .dietaryFatMonounsaturated),
            let polyunsaturatedFat = HKObjectType.quantityType(forIdentifier: .dietaryFatPolyunsaturated),
            let potassium = HKObjectType.quantityType(forIdentifier: .dietaryPotassium),
            let protein = HKObjectType.quantityType(forIdentifier: .dietaryProtein),
            let saturatedFat = HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated),
            let sodium = HKObjectType.quantityType(forIdentifier: .dietarySodium),
            let sugars = HKObjectType.quantityType(forIdentifier: .dietarySugar),
            let thiamin = HKObjectType.quantityType(forIdentifier: .dietaryThiamin),
            let vitaminA = HKObjectType.quantityType(forIdentifier: .dietaryVitaminA),
            let vitaminC = HKObjectType.quantityType(forIdentifier: .dietaryVitaminC),
            let vitaminD = HKObjectType.quantityType(forIdentifier: .dietaryVitaminD),
            let water = HKObjectType.quantityType(forIdentifier: .dietaryWater),
            let caffeine = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) else {
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        // Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [calcium,
                                                        carbohydrate,
                                                        cholesterol,
                                                        energy,
                                                        fiber,
                                                        folate,
                                                        iron,
                                                        monounsaturatedFat,
                                                        polyunsaturatedFat,
                                                        potassium,
                                                        protein,
                                                        saturatedFat,
                                                        sodium,
                                                        sugars,
                                                        thiamin,
                                                        vitaminA,
                                                        vitaminC,
                                                        vitaminD,
                                                        water,
                                                        caffeine,]
        
        let healthKitTypesToRead: Set<HKObjectType> = [calcium,
                                                       carbohydrate,
                                                       cholesterol,
                                                       energy,
                                                       fiber,
                                                       folate,
                                                       iron,
                                                       monounsaturatedFat,
                                                       polyunsaturatedFat,
                                                       potassium,
                                                       protein,
                                                       saturatedFat,
                                                       sodium,
                                                       sugars,
                                                       thiamin,
                                                       vitaminA,
                                                       vitaminC,
                                                       vitaminD,
                                                       water,
                                                       caffeine,]
        
        // Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, error)
        }
    }
    
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        
        // Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        // Prepare the data types that will interact with HealthKit
        guard let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let leanBodyMass = HKObjectType.quantityType(forIdentifier: .leanBodyMass),
            let bodyFatPercentage = HKObjectType.quantityType(forIdentifier: .bodyFatPercentage),
            let waistCircumfrence = HKObjectType.quantityType(forIdentifier: .waistCircumference),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
            let steps = HKObjectType.quantityType(forIdentifier: .stepCount),
            let distance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
        }
        
        // Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                        height,
                                                        bodyMass,
                                                        leanBodyMass,
                                                        bodyFatPercentage,
                                                        waistCircumfrence,
                                                        activeEnergy,
                                                        steps,
                                                        distance,
                                                        HKObjectType.workoutType()]
        
        let healthKitTypesToRead: Set<HKObjectType> = [bodyMassIndex,
                                                       height,
                                                       bodyMass,
                                                       leanBodyMass,
                                                       bodyFatPercentage,
                                                       waistCircumfrence,
                                                       steps,
                                                       distance,
                                                       HKObjectType.workoutType()]
        
        // Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, error)
        }
    }
}
