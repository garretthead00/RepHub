//
//  WorkoutSession.swift
//  RepHub
//
//  Created by Garrett Head on 9/30/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//
// Workout Session details all events that occured over the duration b/w start and end.
// Workouts are made up of intervals (WorkoutInterval). These intervals help to better identify
// what was going on during the workout.

import Foundation

// Describes all the possible states a workout can be in.
enum WorkoutSessionState {
    case notStarted
    case active
    case finished
}

class WorkoutSession {
    
    private (set) var startDate: Date!
    private (set) var endDate: Date!
    private (set) var steps: Int!
    private (set) var distance: Double!
    private (set) var totalEnergyBurned: Double!
    var state: WorkoutSessionState = .notStarted
    var intervals = [WorkoutInterval]()
    var motionTracker = WorkoutMotionTracker()
    var calorieTracker = WorkoutCalorieTracker()
    
    func start() {
        startDate = Date()
        state = .active
        motionTracker.startUpdating()
    }
    
    func end() {
        motionTracker.stopUpdating()
        endDate = Date()
        if let totalSteps = self.motionTracker.totalSteps {
            steps = totalSteps
        } else {
            steps = 0
        }
        if let totalDistance = self.motionTracker.totalDistance {
            distance = totalDistance
        } else {
            distance = 0
        }
        addNewInterval()
        state = .finished
    }
    
    func clear() {
        startDate = nil
        endDate = nil
        steps = 0
        distance = 0.0
        state = .notStarted
        intervals.removeAll()
    }
    
    func updateSessionMetrics(duration: Double) {
        steps = self.motionTracker.totalSteps
        distance = self.motionTracker.totalDistance
        totalEnergyBurned = self.calorieTracker.getTotalEnergyBurned(duration: duration)
    }
    
    private func addNewInterval() {
        let interval = WorkoutInterval(start: startDate, end: endDate, steps: steps, distance: distance)
        print("---workoutSession--- start: \(startDate), end: \(endDate), steps: \(steps), distance: \(distance)")
        intervals.append(interval)
    }
    
    var completeWorkout: ActiveWorkout? {
        get {
            guard state == .finished, intervals.count > 0 else {
                    return nil
            }
            return ActiveWorkout(with: intervals)
        }
    }
}

