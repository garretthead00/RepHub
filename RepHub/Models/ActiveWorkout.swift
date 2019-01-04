//
//  ActiveWorkout.swift
//  RepHub
//
//  Created by Garrett Head on 9/30/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import HealthKit


struct ActiveWorkout {
    var start: Date
    var end: Date
    
    var intervals: [WorkoutInterval]
    
    
    init(with intervals: [WorkoutInterval]) {
        self.start = intervals.first!.start
        self.end = intervals.last!.end
        self.intervals = intervals
    }
    
    var totalEnergyBurned: Double {
        return intervals.reduce(0, { (result, interval) -> Double in
            return result+interval.totalEnergyBurned
        })
    }
    
    var duration: TimeInterval {
        return intervals.reduce(0, { (result, interval) -> TimeInterval in
            return result+interval.duration
        })
    }
    
    var totalSteps: Int {
        return intervals.reduce(0, { (result, interval) -> Int in
            return result+interval.steps!
        })
    }
    
    var totalDistance : Double {
        return intervals.reduce(0, { (result, interval) -> Double in
            return result+interval.distance!
        })
    }
}
