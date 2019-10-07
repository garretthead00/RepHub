//
//  HealthKit_ExerciseService.swift
//  RepHub
//
//  Created by Garrett Head on 10/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

class HealthKit_ExerciseService {
    
    
    func fetchTodaysSteps(completion: @escaping (Double) -> Void) {
        ExerciseActivityStore.getTodaysSteps(completion: {
            result in
            if let steps = result {
                completion(steps)
            }
            completion(0.0)
            return
        })
    }
    
    func fetchTodaysStandHours(completion: @escaping (Double) -> Void) {
        ExerciseActivityStore.getTodaysStandHours(completion: {
            result in
            if let stand = result {
                completion(stand)
            }
            completion(0.0)
            return
        })
    }
    
    func fetchTodaysActiveEnergyBurned(completion: @escaping (Double) -> Void) {
        ExerciseActivityStore.getTodaysActiveEnergyBurned(completion: {
            result in
            if let calories = result {
                completion(calories)
            }
            completion(0.0)
            return
        })
    }

    
}
