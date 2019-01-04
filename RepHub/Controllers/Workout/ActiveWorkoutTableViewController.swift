//
//  ActiveWorkoutTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 11/16/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class ActiveWorkoutTableViewController: UITableViewController {

    var exercises = [WorkoutExercise]()
    var exerciseNames = [String]()
    var workoutId : String? {
        didSet {
            self.loadExercises()
        }
    }
    
    // Workout Totals
    private var totalReps = 0
    private var totalWork = 0.0
    private var totalSteps = 0
    private var caloriesBurned = 0.0
    private var totalDistance = 0.0
    
    // WorkoutTimer
    private var workoutTimer = Timer()
    private var workoutDurationSeconds = 0.0
    private var didStartWorkout = false
    private var didPauseWorkout = false
    
    var session = WorkoutSession()
    
    // Outlets
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var caloriesBurnedLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startWorkout()
    }
    
    private func loadExercises() {
        self.exercises.removeAll()
        self.exerciseNames.removeAll()
        API.WorkoutExercises.observeWorkoutExercises(withId: self.workoutId!, completion: {
            workoutExercise in
            API.Exercise.observeExercise(withId: workoutExercise.exerciseId!, completion: {
                exercise in
                self.exerciseNames.append(exercise.name!)
                self.exercises.append(workoutExercise)
                self.tableView.reloadData()
            })
        })
    }

    private func startWorkout() {
        if didStartWorkout {
            return
        }
        session.start()
        self.workoutTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopWorkout(_ sender: Any) {

        session.end()
        self.totalSteps = session.steps
        self.workoutTimer.invalidate()
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let newWorkoutLogRef = API.WorkoutLog.WORKOUT_LOGS_DB_REF.childByAutoId()
        newWorkoutLogRef.setValue(["workoutId": self.workoutId!, "timestamp": timestamp, "duration": self.workoutDurationSeconds, "totalReps": self.totalReps, "totalWork": self.totalWork, "totalSteps": self.totalSteps, "totalCalories": self.caloriesBurned], withCompletionBlock: {
            error, ref in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            API.UserWorkoutLogs.USER_WORKOUT_LOGS_DB_REF.child(currentUserId).child(newWorkoutLogRef.key).setValue(true, withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                self.workoutDurationSeconds = 0
                self.didStartWorkout = false
                self.totalWork = 0.0
                self.totalReps = 0
                
                // Segue to the WorkoutSurvey with the new workoutLogID
                self.performSegue(withIdentifier: "WorkoutSurvey", sender: newWorkoutLogRef.key)
                // Save to HealthKit
                self.saveWorkout()

            })
        })

    }
    
    private func saveWorkout(){
        if let currentWorkout = self.session.completeWorkout {
            WorkoutStore.save(workout: currentWorkout) {
                (success, error) in
                print("--currentworkout success: \(success)")
                print("--currentworkout error: \(error)")
                if success {
                    WorkoutStore.saveSamples(workout: currentWorkout)
                    self.dismissAndRefreshWorkouts()
                    
                } else {
                    ProgressHUD.showError("Could not save workout data to HealthKit.")
                }
                
            }
        } else {
            fatalError("Shouldn't be able to press the done button without a saved workout.")
        }
    }
    
    private func dismissAndRefreshWorkouts() {
        session.clear()
    }
    
    @objc private func updateView() {
        //self.workoutDurationSeconds += 1
        if let startDate = session.startDate {
            let duration = Date().timeIntervalSince(startDate)
            self.workoutDurationSeconds = duration
            self.timeDurationLabel.text = durationFormatter.string(from: duration)
            session.updateSessionMetrics(duration: duration)
        }

        if let steps = session.steps {
            self.stepsLabel.text = "\(steps) steps"
            self.totalSteps = steps
        }
        
        if let distance = session.distance {
            let distanceStr = String(format: "%.2f", distance)
            self.distanceLabel.text = "\(distanceStr) mi"
            self.totalDistance = distance
        }
        
        self.repsLabel.text = "\(totalReps) reps"

        if let totalEnergyBurned = session.totalEnergyBurned {
            let totalEnergyBurnedStr = String(format: "%.2f", totalEnergyBurned)
            self.caloriesBurnedLabel.text = totalEnergyBurnedStr + " kCals"
            self.caloriesBurned = totalEnergyBurned
        }
        
    }
    
    
    private lazy var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }

    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise", for: indexPath)
         var detailString = ""
         if let breakTime = self.exercises[indexPath.row].breakTime {
         detailString += " break: \(breakTime)"
         }
         if let targetSets = self.exercises[indexPath.row].targetSets, let targetReps = self.exercises[indexPath.row].targetReps {
         detailString += " targets: \(targetSets) x \(targetReps)"
         }
         cell.textLabel?.text = self.exerciseNames[indexPath.row]
         cell.detailTextLabel?.text = detailString
         return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.exercises[indexPath.row].exerciseId!
        self.performSegue(withIdentifier: "ExerciseLog", sender: id)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExerciseLog" {
            let exerciseLogVC = segue.destination as! ExerciseLogViewController
            let exeriseId = sender as? String
            exerciseLogVC.exerciseId = exeriseId
            exerciseLogVC.delegate = self
        }
        if segue.identifier == "WorkoutSurvey" {
            let workoutSurveyVC = segue.destination as! WorkoutSurveyViewController
            let workoutLogId = sender as? String
            workoutSurveyVC.workoutLogId = workoutLogId
            //workoutSurveyVC.delegate = self
        }
    }

    
}

extension ActiveWorkoutTableViewController : ExerciseLogDelegate {
    func updateTotals(reps: Int?, weight: Double?) {
        self.totalReps += reps!
        self.totalWork += weight!
        print("total Reps: \(self.totalReps) total work: \(self.totalWork)")
    }
    
    
}
