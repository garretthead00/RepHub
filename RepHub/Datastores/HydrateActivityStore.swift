//
//  HydrateActivityStore.swift
//  RepHub
//
//  Created by Garrett Head on 10/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import HealthKit


class HydrateActivityStore {
    
    class func getTodaysWaterDrank(completion: @escaping(Double?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let waterDrankQuantityType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else {
            print("*** Unable to create a waterDrank type ***")
            fatalError("*** Unable to create a waterDrank type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: waterDrankQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            DispatchQueue.main.async {
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(nil, error)
                    return
                }
                completion(sum.doubleValue(for: HKUnit.fluidOunceUS()), nil)
            }
        }
        HKHealthStore().execute(query)
    }
    
    class func getTodaysCaffeine(completion: @escaping(Double?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let caffeineQuantityType = HKSampleType.quantityType(forIdentifier: .dietaryCaffeine) else {
            print("*** Unable to create a caffeine type ***")
            fatalError("*** Unable to create a caffeine type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: caffeineQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            DispatchQueue.main.async {
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(nil, error)
                    return
                }
                completion(sum.doubleValue(for: HKUnit.gramUnit(with: .milli)), nil)
            }
        }
        HKHealthStore().execute(query)
    }
    
    
    // NOTE!!!! This pulls all sugar data; not exlcusive to what was drank....
    // Need to understand how to correlate sugar with drinks...Correlation Type?
    class func getTodaysSugar(completion: @escaping(Double?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let sugarQuantityType = HKSampleType.quantityType(forIdentifier: .dietarySugar) else {
            print("*** Unable to create a sugar type ***")
            fatalError("*** Unable to create a sugar type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: sugarQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            DispatchQueue.main.async {
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(nil, error)
                    return
                }
                completion(sum.doubleValue(for: HKUnit.gram()), nil)
            }
        }
        HKHealthStore().execute(query)
    }
    
}
