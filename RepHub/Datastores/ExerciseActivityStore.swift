//
//  ExerciseActivityStore.swift
//  RepHub
//
//  Created by Garrett Head on 9/26/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import HealthKit



class ExerciseActivityStore {
    
    class func getTodaysSteps(completion: @escaping (Double?, Error?) -> Void){
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let stepsQuantityType = HKSampleType.quantityType(forIdentifier: .stepCount) else {
            print("*** Unable to create a steps type ***")
            fatalError("*** Unable to create a steps type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            DispatchQueue.main.async {
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(nil, error)
                    return
                }
                completion(sum.doubleValue(for: HKUnit.count()), nil)
            }
        }
        HKHealthStore().execute(query)
    }
    
    class func getTodaysStandHours(completion: @escaping (Double?, Error?) -> Void){
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let standQuantityType = HKSampleType.quantityType(forIdentifier: .appleStandTime) else {
            print("*** Unable to create a standTime type ***")
            fatalError("*** Unable to create a standTime type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: standQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            DispatchQueue.main.async {
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(nil, error)
                    return
                }
                completion(sum.doubleValue(for: HKUnit.minute()), nil)
            }
        }
        HKHealthStore().execute(query)
        
    }
    
    class func getTodaysActiveEnergyBurned(completion: @escaping (Double?, Error?) -> Void){
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        guard let activeEnergyQuantityType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("*** Unable to create a activeEnergy type ***")
            fatalError("*** Unable to create a activeEnergy type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: activeEnergyQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) {
            (query, result, error) in
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
    
    // Returns an array of total calories burned per hour for the current day.
    class func getHourlyActiveEnergyBurned(completion: @escaping([(Date,Double,String)]?, Error?) -> Void) {
        guard let energyBurnedQuantityType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("*** Unable to create a energyBurned type ***")
            fatalError("*** Unable to create a energyBurned type ***")
        }
        
        var calendar = Calendar.current
        calendar.timeZone = .current
        var interval = DateComponents()
        interval.hour = 1
        var data : [(Date, Double, String)] = []
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .hour, value: 23, to: startDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let anchorDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
        let query = HKStatisticsCollectionQuery(quantityType: energyBurnedQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval)

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
                    data.append((result.startDate, value, HKUnit.largeCalorie().unitString))
                })
                completion(data, nil)
            }
        }

        HKHealthStore().execute(query)
    }
    
}
