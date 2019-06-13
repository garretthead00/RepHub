//
//  WorkoutMotionTracker.swift
//  RepHub
//
//  Created by Garrett Head on 10/18/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
// WorkoutMotionTracker handles all motion events that occur during a workout session.
// Data tracked includes steps, distance, & flightsAscended.


import Foundation
import CoreMotion

class WorkoutMotionTracker {
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    var activityType : String?
    var totalSteps : Int?
    var totalDistance : Double?
    var flightsAscended : String?
    
    func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    self?.activityType = "Walking"
                    print("activityType = Walking")
                } else if activity.stationary {
                    self?.activityType = "Stationary"
                    print("activityType = Stationary")
                } else if activity.running {
                    self?.activityType = "Running"
                     print("activityType = Running")
                } else if activity.automotive {
                    self?.activityType = "Automotive"
                     print("activityType = Automotive")
                }
            }
        }
    }
    
    private func startCountingSteps() {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.totalSteps = pedometerData.numberOfSteps.intValue
                self?.totalDistance = self!.miles(meters: pedometerData.distance!.doubleValue)
                self?.flightsAscended = pedometerData.floorsAscended?.stringValue
                let totalStepsStr = pedometerData.numberOfSteps.stringValue
                let distanceStr = pedometerData.distance!.stringValue
                let flightsStr = pedometerData.floorsAscended!.stringValue
                print("totalSteps = \(totalStepsStr)")
                print("totalDistance = \(distanceStr)")
                print("flight = \(flightsStr)")
            }
        }
    }
    
    func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        }
    }
    
    func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }
    
    
    //-- CONVERSIONS
    
    func miles(meters:Double) -> Double{
        let mile = 0.000621371192
        return meters * mile
    }
    
    func kilometers(meters: Double) -> Double {
        return meters * 1000
    }
    
}
