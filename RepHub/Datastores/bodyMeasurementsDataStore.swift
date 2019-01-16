//
//  bodyMeasurementsDataStore.swift
//  RepHub
//
//  Created by Garrett Head on 9/22/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import HealthKit

class bodyMeasurementsDataStore {
    
    
    class func getMostRecentSample(for sampleType: HKSampleType, completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        //1. Use HKQuery to load the most recent samples.
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 1
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                                            
            //2. Always dispatch to the main thread when complete.
            DispatchQueue.main.async {
                
                guard let samples = samples,
                    let mostRecentSample = samples.first as? HKQuantitySample else {
                        completion(nil, error)
                        return
                }
                completion(mostRecentSample, nil)
            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }

    class func saveHeightSample(height: Double, date: Date) {
        if let heightType = HKQuantityType.quantityType(forIdentifier: .height) {
            let heightQuantity = HKQuantity(unit: HKUnit.foot(), doubleValue: height)
            let heightSample = HKQuantitySample(type: heightType, quantity: heightQuantity, start: date, end: date)
            HKHealthStore().save(heightSample) { (success, error) in
                if let error = error {
                    print("Error Saving heightSample: \(error.localizedDescription)")
                } else {
                    print("Successfully saved heightSample")
                }
            }
        }
        else {
            fatalError("Height Type is no longer available in HealthKit")
        }
    }
    
    class func saveWeightSample(weight: Double, date: Date) {
        if let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass) {
            let weightQuantity = HKQuantity(unit: HKUnit.init(from: .pound), doubleValue: weight)
            let weightSample = HKQuantitySample(type: weightType,quantity: weightQuantity,start: date,end: date)
            HKHealthStore().save(weightSample) { (success, error) in
                if let error = error {
                    print("Error Saving weightSample: \(error.localizedDescription)")
                } else {
                    print("Successfully saved weightSample")
                }
            }
        }
        else {
            fatalError("Body Mass Type is no longer available in HealthKit")
        }
    }
    
    class func saveBodyMassIndexSample(bodyMassIndex: Double, date: Date) {
        if let bodyMassIndexType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex) {
            let bodyMassQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: bodyMassIndex)
            let bodyMassIndexSample = HKQuantitySample(type: bodyMassIndexType, quantity: bodyMassQuantity, start: date, end: date)
            HKHealthStore().save(bodyMassIndexSample) { (success, error) in
                if let error = error {
                    print("Error Saving BMI Sample: \(error.localizedDescription)")
                } else {
                    print("Successfully saved BMI Sample")
                }
            }
        } else {
            fatalError("Body Mass Index Type is no longer available in HealthKit")
        }
    }
    
    class func saveLeanBodyMassSample(leanBodyMass: Double, date: Date) {
        
        if let leanBodyMassType = HKQuantityType.quantityType(forIdentifier: .leanBodyMass) {
            let leanBodyMassQuantity = HKQuantity(unit: HKUnit.init(from: .pound), doubleValue: leanBodyMass)
            let leanBodyMassSample = HKQuantitySample(type: leanBodyMassType, quantity: leanBodyMassQuantity, start: date, end: date)
            HKHealthStore().save(leanBodyMassSample) { (success, error) in
                if let error = error {
                    print("Error Saving lean body mass Sample: \(error.localizedDescription)")
                } else {
                    print("Successfully saved lean body mass Sample")
                }
            }
        } else {
            fatalError("Lean Body Mass Type is no longer available in HealthKit")
        }
    }
    
    
    class func saveWaistCircumferenceSample(waistCircumference: Double, date: Date) {
        
        // .waistCircumference
        if let waistCircumferenceType = HKQuantityType.quantityType(forIdentifier: .waistCircumference)  {
            let waistCircumferenceQuantity = HKQuantity(unit: HKUnit.init(from: .inch), doubleValue: waistCircumference)
            let waistCircumferenceSample = HKQuantitySample(type: waistCircumferenceType,quantity: waistCircumferenceQuantity,start: date,end: date)
            HKHealthStore().save(waistCircumferenceSample) { (success, error) in
                if let error = error {
                    print("Error Saving waistCircumference Sample: \(error.localizedDescription)")
                } else {
                    print("Successfully saved waistCircumference Sample")
                }
            }
        } else {
            print("waistCircumference Type is no longer available in HealthKit")
        }
    }
    
    class func saveBodyFatPercentageSample(bodyFatPercentage: Double, date: Date) {
        
        // .bodyFatPercentage
        if let bodyFatPercentageType = HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)  {
            let bodyFatPercentageQuantity = HKQuantity(unit: HKUnit.percent(), doubleValue: bodyFatPercentage)
            let bodyFatPercentageSample = HKQuantitySample(type: bodyFatPercentageType, quantity: bodyFatPercentageQuantity, start: date, end: date)
            HKHealthStore().save(bodyFatPercentageSample) { (success, error) in
                if let error = error {
                    print("Error Saving bodyFatPercentage Sample: \(error.localizedDescription)")
                } else {
                    print("Successfully saved bodyFatPercentage Sample")
                }
            }
        } else {
            print("bodyFatPercentage Type is no longer available in HealthKit")
        }
    }
    
    
}

