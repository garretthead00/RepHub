//
//  EatActivityStore.swift
//  RepHub
//
//  Created by Garrett Head on 10/12/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import HealthKit

class EatActivityStore {
    
    class func getTodaysEnergyConsumed(completion: @escaping(Double?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let energyConsumedQuantityType = HKSampleType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("*** Unable to create a energyConsumed type ***")
            fatalError("*** Unable to create a energyConsumed type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: energyConsumedQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            DispatchQueue.main.async {
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(nil, error)
                    return
                }
                completion(sum.doubleValue(for: HKUnit.largeCalorie()), nil)
            }
        }
        HKHealthStore().execute(query)
    }
    
    class func getTodaysProteinConsumed(completion: @escaping(Double?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let proteinConsumedQuantityType = HKSampleType.quantityType(forIdentifier: .dietaryProtein) else {
            print("*** Unable to create a proteinConsumed type ***")
            fatalError("*** Unable to create a proteinConsumed type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: proteinConsumedQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
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
    
    class func getTodaysFatConsumed(completion: @escaping(Double?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let fatConsumedQuantityType = HKSampleType.quantityType(forIdentifier: .dietaryProtein) else {
            print("*** Unable to create a fatConsumed type ***")
            fatalError("*** Unable to create a fatConsumed type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: fatConsumedQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
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
    
    class func getTodaysCarbohydratesConsumed(completion: @escaping(Double?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let carbohydratesConsumedQuantityType = HKSampleType.quantityType(forIdentifier: .dietaryProtein) else {
            print("*** Unable to create a carbohydratesConsumedQuantityType type ***")
            fatalError("*** Unable to create a carbohydratesConsumedQuantityType type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: carbohydratesConsumedQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) {
            (query, result, error) in
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
    
    
    // Returns an array of total calories consumed per hour for the current day.
    class func getHourlyEnergyConsumedTotal(completion: @escaping([(Date,Double,HKUnit)]?, Error?) -> Void) {
        guard let energyConsumedQuantityType = HKSampleType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("*** Unable to create a energyConsumed type ***")
            fatalError("*** Unable to create a energyConsumed type ***")
        }
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        var interval = DateComponents()
        interval.hour = 1
        var data : [(Date, Double, HKUnit)] = []
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .hour, value: 23, to: startDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let anchorDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
        let query = HKStatisticsCollectionQuery(quantityType: energyConsumedQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval)

        query.initialResultsHandler = {
            query, results, error in

            DispatchQueue.main.async {
                guard let results = results else {
                    completion(nil, error)
                    return
                }

                results.enumerateStatistics(from: startDate, to: endDate!, with: {
                    (result, stop) in
                    let value = result.sumQuantity()?.doubleValue(for: HKUnit.largeCalorie()) ?? 0
                    data.append((result.startDate, value, HKUnit.largeCalorie()))
                })
                completion(data, nil)
            }
        }

        HKHealthStore().execute(query)
    }
    
    
    
}
