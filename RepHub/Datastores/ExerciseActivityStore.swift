//
//  ExerciseActivityStore.swift
//  RepHub
//
//  Created by Garrett Head on 9/26/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import HealthKit



class ExerciseActivityStore {
    
    class func getTodaysSteps(completion: @escaping (Double?) -> Void){
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let stepsQuantityType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            print("*** Unable to create a steps type ***")
            fatalError("*** Unable to create a steps type ***")
        }
        //let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        HKHealthStore().execute(query)
    }
    
    class func getTodaysStandHours(completion: @escaping (Double?) -> Void){
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let standQuantityType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleStandTime) else {
            print("*** Unable to create a standTime type ***")
            fatalError("*** Unable to create a standTime type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: standQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil)
                return
            }
            completion(sum.doubleValue(for: HKUnit.minute()))
        }
        HKHealthStore().execute(query)
        
    }
    
    class func getTodaysActiveEnergyBurned(completion: @escaping (Double?) -> Void){
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let activeEnergyQuantityType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            print("*** Unable to create a standTime type ***")
            fatalError("*** Unable to create a standTime type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: activeEnergyQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil)
                return
            }
            completion(sum.doubleValue(for: HKUnit.largeCalorie()))
        }
        HKHealthStore().execute(query)
        
    }
    
}
