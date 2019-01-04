//
//  WorkoutStore.swift
//  RepHub
//
//  Created by Garrett Head on 9/30/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import HealthKit

class WorkoutStore {
    
    class func save(workout: ActiveWorkout, completion: @escaping ((Bool, Error?) -> Void)) {
        
        //1. Setup the Calorie Quantity for total energy burned
        let calorieQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: workout.totalEnergyBurned)
        
        //2. Build the workout using data from your Prancercise workout
        let hkWorkout = HKWorkout(activityType: .other, start: workout.start, end: workout.end, duration: workout.duration, totalEnergyBurned: calorieQuantity, totalDistance: nil, device: HKDevice.local(), metadata: nil)
        

        //3. Save your workout to HealthKit
        let healthStore = HKHealthStore()
        let samples = self.samples(for: workout)
        print("saving Workout")
        healthStore.save(hkWorkout) { (success, error) in
            print("--healthstore success: \(success)")
            print("--healthstore error: \(error)")
            guard error == nil else {
                completion(false, error)
                return
            }
            completion(true, nil)
//            print("--healthstore adding samples")
//            healthStore.add(samples, to: hkWorkout, completion: { (samples, error) in
//                print("--healthstore adding samples success: \(success)")
//                print("--healthstore adding samples error: \(error)")
//                guard error == nil else {
//                    completion(false, error)
//                    return
//                }
//                completion(true, nil)
//
//            })
        }

    }
    
    class func saveSamples(workout: ActiveWorkout) {
        let healthStore = HKHealthStore()
        print("saving stepCount")
        // stepCount
        guard let totalStepsType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            print("*** Unable to create a Step Count type ***")
            fatalError("*** Unable to create a Step Count type ***")
            
        }
        let stepCountQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: Double(workout.totalSteps))
        //let stepCountForInterval = HKQuantity(unit: HKUnit.count(), doubleValue: Double(interval.steps!))
        let stepCountForIntervalSample = HKQuantitySample(type: totalStepsType, quantity: stepCountQuantity, start: NSDate() as Date, end: Date())
        
        healthStore.save(stepCountForIntervalSample, withCompletion: { (success, error) -> Void in
            if success {
                // handle success
                ProgressHUD.showSuccess("Steps saved to HealthKit")
            } else {
                // handle error
                ProgressHUD.showError("Steps NOT saved to HealthKit")
            }
        })
        
        print("saving distance")
        // distance
        guard let distanceType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning) else {
            print("*** Unable to create a Step Count type ***")
            fatalError("*** Unable to create a Step Count type ***")
            
        }
        let distanceQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: Double(workout.totalDistance))
        //let stepCountForInterval = HKQuantity(unit: HKUnit.count(), doubleValue: Double(interval.steps!))
        let distanceForIntervalSample = HKQuantitySample(type: distanceType, quantity: distanceQuantity, start: NSDate() as Date, end: Date())
        
        healthStore.save(distanceForIntervalSample, withCompletion: { (success, error) -> Void in
            if success {
                // handle success
                ProgressHUD.showSuccess("distance saved to HealthKit")
            } else {
                // handle error
                ProgressHUD.showError("distance NOT saved to HealthKit")
            }
        })
    }
    
    private class func samples(for workout: ActiveWorkout) -> [HKSample] {

        var samples = [HKSample]()

        guard let energyBurnedQuantityType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            print("*** Energy Burned Type Not Available ***")
            fatalError("*** Energy Burned Type Not Available ***")
            
        }
        
        guard let distanceType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning) else {
            print("*** Unable to create a distance type ***")
            fatalError("*** Unable to create a distance type ***")
            
        }
        
        guard let heartRateType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            print("*** Unable to create a heart rate type ***")
            fatalError("*** Unable to create a heart rate type ***")
            
        }
        
        guard let totalStepsType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            print("*** Unable to create a Step Count type ***")
            fatalError("*** Unable to create a Step Count type ***")
        }
    
        for interval in workout.intervals {
            // total energy burned
            let energyBurnedSampleQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: interval.totalEnergyBurned)
            let energyBurnedSample = HKQuantitySample(type: energyBurnedQuantityType, quantity: energyBurnedSampleQuantity, start: interval.start, end: interval.end)
            samples.append(energyBurnedSample)
            
            // distance traveled
            let distancePerInterval = HKQuantity(unit: HKUnit.mile(), doubleValue: interval.distance!)
            let distancePerIntervalSample = HKQuantitySample(type: distanceType, quantity: distancePerInterval, start: interval.start, end: interval.end)
            samples.append(distancePerIntervalSample)
            
            // heart rate
            let heartRateForInterval = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 95.0)
            let heartRateForIntervalSample = HKQuantitySample(type: heartRateType, quantity: heartRateForInterval, start: interval.start, end: interval.end)
            samples.append(heartRateForIntervalSample)
            
           // stepCount
            let stepCountForInterval = HKQuantity(unit: HKUnit.count(), doubleValue: Double(interval.steps!))
            let stepCountForIntervalSample = HKQuantitySample(type: totalStepsType, quantity: stepCountForInterval, start: interval.start, end: interval.end)
            samples.append(stepCountForIntervalSample)
            
        }

        return samples
    }
//
//    class func loadPrancerciseWorkouts(completion: @escaping (([HKWorkout]?, Error?) -> Swift.Void)){
//
//        //1. Get all workouts with the "Other" activity type.
//        let workoutPredicate = HKQuery.predicateForWorkouts(with: .other)
//
//        //2. Get all workouts that only came from this app.
//        let sourcePredicate = HKQuery.predicateForObjects(from: HKSource.default())
//
//        //3. Combine the predicates into a single predicate.
//        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [workoutPredicate,
//                                                                           sourcePredicate])
//
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
//                                              ascending: true)
//
//        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(),
//                                  predicate: compound,
//                                  limit: 0,
//                                  sortDescriptors: [sortDescriptor]) { (query, samples, error) in
//
//                                    DispatchQueue.main.async {
//
//                                        //4. Cast the samples as HKWorkout
//                                        guard let samples = samples as? [HKWorkout],
//                                            error == nil else {
//                                                completion(nil, error)
//                                                return
//                                        }
//
//                                        completion(samples, nil)
//                                    }
//        }
//
//        HKHealthStore().execute(query)
//    }
}


