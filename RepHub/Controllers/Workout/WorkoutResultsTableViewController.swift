//
//  WorkoutResultsTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 5/28/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class WorkoutResultsTableViewController: UITableViewController {

    
    // Workout Results
    var totalReps : Int?
    var totalWork : Double?
    var totalSteps : Int?
    var caloriesBurned : Double?
    var totalDistance : Double?
    var workoutDurationSeconds : Double?
    
    var workout : ActiveWorkout?
    var exerciseScores = [Int]()
    var workoutScore = 0
    var exercises : [WorkoutExercise]? {
        didSet {
//            getScores()
//            self.workoutScore = calculateWorkoutScore()
            calculateWorkoutResults()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func getScores(){
        for exercise in self.exercises! {
            let score = calculateExerciseScore(exercise: exercise)
            self.exerciseScores.append(score)
        }
    }
    
    private func calculateWorkoutResults(){
        var workoutTotal = 0.0
        var totalWorkoutLogValue = 0
        var totalWorkoutTargets = 0
        var totalReps = 0
        var totalWork = 0
        
        for exercise in self.exercises! {
            var exerciseScore = 0
            var targetTotal = 0
            var totalLogValue = 0
            if let logs = exercise.logs, logs.count > 0 {
                for log in logs {
                    totalLogValue = totalLogValue + log.value!
                    totalWork = totalWork + (totalLogValue * Int(log.weightLB!))
                }
            }
            targetTotal = targetTotal + (exercise.sets! * exercise.target!)
            if targetTotal > 0 {
                exerciseScore = Int((Double(totalLogValue) / Double(targetTotal)) * 100)
            } else {
                exerciseScore = 0
            }
            self.exerciseScores.append(exerciseScore)
            totalWorkoutLogValue = totalWorkoutLogValue + totalLogValue
            totalWorkoutTargets = totalWorkoutTargets + targetTotal
            
            if exercise.metricType != "Repitition" {
                totalReps = totalReps + (totalLogValue / exercise.target!)
            } else {
                totalReps = totalReps + totalLogValue
            }

        }
        workoutTotal = workoutTotal + (Double(totalWorkoutLogValue) / Double(totalWorkoutTargets))
        self.workoutScore = Int(workoutTotal * 100)
        self.totalWork = Double(totalWork)
        self.totalReps = totalReps
    }
    
    
    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        self.saveWorkoutToHealthKit()
        self.saveWorkout()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises!.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutResults", for: indexPath) as! WorkoutResultsTableViewCell
            cell.totalReps = self.totalReps
            cell.totalSteps = self.totalSteps
            cell.totalWork = self.totalWork
            cell.totalDistance = self.totalDistance
            cell.durationString = convertDurationString(durationInSeconds: self.workoutDurationSeconds!)
            cell.caloriesBurned = self.caloriesBurned
            cell.score = self.workoutScore
            return cell
        } else {
            let exercise = self.exercises![indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseResults", for: indexPath) as! ExerciseResultsTableViewCell
            cell.score = exerciseScores[indexPath.row - 1]
            cell.restTime = 30
            cell.exercise = exercise
            return cell
        }

    }
 
    
    private func calculateExerciseScore(exercise: WorkoutExercise) -> Int {
        var score = 0
        if let logs = exercise.logs, logs.count > 0 {
            for log in logs {
                score = score + log.value!
            }
            score = Int((Double(score) / (Double(exercise.sets!) * Double(exercise.target!))) * 100)
        }
        return score
    }
    
    private func calculateWorkoutScore() -> Int {
        var sumValues = 0
        var sumTargets = 0
        
        for exercise in self.exercises! {
            var score = 0
            if let logs = exercise.logs, logs.count > 0 {
                for log in logs {
                    score = score + log.value!
                }
                sumValues = sumValues + score
            }
            sumTargets = sumTargets + (exercise.sets! * exercise.target!)
        }
        
        let sumValDBL = Double(sumValues)
        let sumTargetsDBL = Double(sumTargets)
        let finalScore = sumValDBL / sumTargetsDBL * 100
        return Int(finalScore)
    }

    private func saveWorkout(){
        guard let currentUserId = API.RepHubUser.CURRENT_USER?.uid else {
            return
        }
        API.WorkoutLog.createNewWorkoutLog(withUserId: currentUserId, workoutDurationSeconds: self.workoutDurationSeconds!, totalReps: self.totalReps!, totalDistance: self.totalDistance!, totalSteps: self.totalSteps!, energyBurned: self.caloriesBurned!, totalWork: self.totalWork!, score: self.workoutScore, completion: {
            workoutLogKey in
            for exercise in self.exercises! {
                for (index, element) in exercise.logs!.enumerated() {
                    API.ExerciseLog.createExerciseLog(withId: workoutLogKey, set: index, reps: element.value!, weight: element.weightLB!, score: element.score!, metricUnit: element.metricUnit!, workoutExerciseId: exercise.id!)
                }
            }
        })
    }
    
    private func saveWorkoutToHealthKit(){
        if let currentWorkout = self.workout {
            WorkoutStore.save(workout: currentWorkout) {
                (success, error) in
                if success {
                    WorkoutStore.saveSamples(workout: currentWorkout)
                    ProgressHUD.showSuccess("Workout saved!")
                } else {
                    ProgressHUD.showError("Could not save workout data to HealthKit.")
                }
            }
        } else {
            fatalError("Shouldn't be able to press the done button without a saved workout.")
        }
    }
    
    
    private func convertDurationString(durationInSeconds : Double) -> String {
        let secondsInt = Int(durationInSeconds)
        let hours = secondsInt / 3600
        let minutes = (secondsInt / 60) % 60
        let seconds = secondsInt % 60
        return "\(hours)h \(minutes)m \(seconds)s"
        
    }
    
}
