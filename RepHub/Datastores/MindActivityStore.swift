//
//  MindActivityStore.swift
//  RepHub
//
//  Created by Garrett Head on 10/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import HealthKit

class MindActivityStore {
    
    class func getTodaysMindfulMinutes(completion: @escaping(TimeInterval?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        guard let mindfulMinutesSampleType = HKSampleType.categoryType(forIdentifier: .mindfulSession) else {
            print("*** Unable to create a mindfulMinutes type ***")
            fatalError("*** Unable to create a mindfulMinutes type ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let q = HKSampleQuery(sampleType: mindfulMinutesSampleType, predicate: predicate, limit: 0, sortDescriptors: [], resultsHandler: {
            (query, result, error) in
            DispatchQueue.main.async {
                guard let results = result else {
                    completion(nil, error)
                    return
                }
                var totalTime = TimeInterval()
                for result in results {
                    totalTime += result.endDate.timeIntervalSince(startOfDay)
                }
                completion(totalTime, nil)
            }
        })
        
        
        HKHealthStore().execute(q)
    }
    

    
    
    
    
}
