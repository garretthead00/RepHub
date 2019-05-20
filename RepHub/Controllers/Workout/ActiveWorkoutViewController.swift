//
//  ActiveWorkoutViewController.swift
//  RepHub
//
//  Created by Garrett on 2/28/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class ActiveWorkoutViewController: UIViewController {

    // Outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var energyBurnedLabel: UILabel!
    @IBOutlet weak var totalRepsLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var totalStepsLabel: UILabel!
    
    
    // Workout
    var exercises = [WorkoutExercise]()
    var exerciseNames = [String]()
    var workoutId : String?

    var workoutLogId : String? {
        didSet {
            self.refreshController()
            
        }
    }
    
    // Workout Totalizers
    private var totalReps = 0
    private var totalWork = 0.0
    private var totalSteps = 0
    private var caloriesBurned = 0.0
    private var totalDistance = 0.0
    
    // Workout Timer
    private var workoutTimer = Timer()
    private var workoutDurationSeconds = 0.0
    
    // Workout Sesion
    var session = WorkoutSession()
    private var didStartWorkout = false
    private var didPauseWorkout = false
    
    private let breakOptions = ["Set", "15 seconds", "30 seconds", "45 seconds", "1 minute", "1.5 minutes", "2 minutes", "2.5 minutes", "3 minutes", "5 minutes", "10 minutes", "15 minutes"]
    private let breakInSeconds = [15, 30, 45, 60, 90, 120, 150, 180, 300, 600, 900]
    private var selectedBreak = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        print("initializing new workout log"...)
        self.createNewWorkoutLog()
        print("starting workout...")
        self.startWorkout()
    }
    
    // Actions
    @IBAction func pauseWorkoutButton_TouchUpInside(_ sender: Any) {
    }
    
    @IBAction func endWorkoutButton_TouchUpInside(_ sender: Any) {
        self.endWorkout()
    }
    
    
    private func refreshController(){
        self.exercises = []
        self.exerciseNames = []
        loadWorkoutExercises()
        
    }
    
    private func loadWorkoutExercises() {
        API.WorkoutExercises.observeWorkoutExercises(withId: self.workoutId!, completion: {
            workoutExercise in
            API.Exercise.observeExercise(withId: workoutExercise.exerciseId!, completion: {
                exercise in
                self.exercises.append(workoutExercise)
                self.exerciseNames.append(exercise.name!)
                self.tableview.reloadData()
                API.ExerciseTarget.observeExerciseTarget(withId: workoutExercise.id!, completion: {
                    target in
                    workoutExercise.targets?.append(target)
                    self.tableview.reloadData()
                })

                print("workoutlogId: \(self.workoutLogId) with: \(workoutExercise.id!)")
                API.WorkoutExerciseLogs.observeWorkoutExerciseLogs(workoutLogId: self.workoutLogId!, workoutExerciseId: workoutExercise.id!, completion: {
                    log in
                    workoutExercise.logs?.append(log)
                    print("got a log")
                    self.tableview.reloadData()
                })
            })
        })
    }
    
    private func loadWorkoutExerciseLogs(){

    }


    private func createNewWorkoutLog(){
        // Create a reference for user-workout-logs.
        guard let currentUserId = API.RepHubUser.CURRENT_USER?.uid else {
            return
        }
        API.UserWorkoutLogs.createUserWorkoutLog(withUserId: currentUserId, workoutId: self.workoutId!, completion: {
            key in
            print("workoutID: \(key)")
            self.workoutLogId = key
        })
    }
    
    private func startWorkout() {
        if didStartWorkout {
            return
        }
        session.start()
        self.workoutTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
    }
    
    @objc private func updateView() {
        //self.workoutDurationSeconds += 1
        if let startDate = session.startDate {
            let duration = Date().timeIntervalSince(startDate)
            self.workoutDurationSeconds = duration
            self.timeElapsedLabel.text = durationFormatter.string(from: duration)
            session.updateSessionMetrics(duration: duration)
        }
        
        if let steps = session.steps {
            self.totalStepsLabel.text = "\(steps) steps"
            self.totalSteps = steps
        }
        
        if let distance = session.distance {
            let distanceStr = String(format: "%.2f", distance)
            self.totalDistanceLabel.text = "\(distanceStr) mi"
            self.totalDistance = distance
        }
        
        self.totalRepsLabel.text = "\(totalReps) reps"
        
        if let totalEnergyBurned = session.totalEnergyBurned {
            let totalEnergyBurnedStr = String(format: "%.2f", totalEnergyBurned)
            self.energyBurnedLabel.text = totalEnergyBurnedStr + " kCals"
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
    
    private func endWorkout(){
        session.end()
        self.totalSteps = session.steps
        self.workoutTimer.invalidate()
        self.saveWorkoutToHealthKit()
        self.saveWorkout()
    
    }
    
    private func saveWorkout(){
        API.WorkoutLog.createNewWorkoutLog(withId: self.workoutLogId!, workoutDurationSeconds: self.workoutDurationSeconds, totalReps: self.totalReps, totalDistance: self.totalDistance, totalSteps: self.totalSteps, energyBurned: self.caloriesBurned, totalWork: self.totalWork, completion: {
            workoutLog in
            self.dismissAndRefreshWorkouts()
        })
    }
    
    private func saveWorkoutToHealthKit(){
        if let currentWorkout = self.session.completeWorkout {
            WorkoutStore.save(workout: currentWorkout) {
                (success, error) in
                if success {
                    WorkoutStore.saveSamples(workout: currentWorkout)
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
        self.workoutDurationSeconds = 0
        self.didStartWorkout = false
        self.totalWork = 0.0
        self.totalReps = 0
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ActiveWorkoutViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveExerciseTargetsTableViewCell", for: indexPath) as! ActiveExerciseTargetsTableViewCell
        cell.exercise = self.exercises[indexPath.row]
        cell.exerciseName = self.exerciseNames[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.exercises[indexPath.row].targets != nil, let count = self.exercises[indexPath.row].targets?.count, count > 0 {
            return calculateRowHeight(count: count)
        }
        else { return calculateRowHeight(count: 1) }
    }
    
    private func calculateRowHeight(count : Int) -> CGFloat {
        let totalItem: CGFloat = CGFloat(count)
        let totalCellInARow: CGFloat = 2
        let cellHeight: CGFloat = 44
        let collViewTopOffset: CGFloat = 10
        let collViewBottomOffset: CGFloat = 10
        let minLineSpacing: CGFloat = 5
        let headerHeight : CGFloat = 50
        
        // calculations
        let totalRow = ceil(totalItem / totalCellInARow)
        let totalTopBottomOffset = collViewTopOffset + collViewBottomOffset
        let totalSpacing = CGFloat(totalRow) * minLineSpacing
        return (cellHeight * totalRow) + totalTopBottomOffset + totalSpacing + headerHeight
    }
    
    
    
    
}

extension ActiveWorkoutViewController : ActiveWorkoutExerciseTargetsDelegate {
    
    func startBreak(withWorkoutExerciseId id: String) -> Int {
        print("setting break for exercise with id: \(id)")
        setBreak(withId: id)
        return 0
        

    }
    
    func addAdditionalExerciseLog(withWorkoutExerciseId id: String, exerciseId: String, set: Int) {
        print("add additional exercise log to workoutExerciseId \(id) for set \(set) of exerciseId \(exerciseId)")
        promptExerciseLogMenu(withWorkoutExerciseId: id, exerciseId: exerciseId, set: set)
        
    }
    
    func addExerciseLog(withWorkoutExerciseId id: String, exerciseId: String, set: Int) {
        print("add exercise log to workoutExerciseId \(id) for set \(set) of exerciseId \(exerciseId)")
        promptExerciseLogMenu(withWorkoutExerciseId: id, exerciseId: exerciseId, set: set)
        
    }
    
    private func promptExerciseLogMenu(withWorkoutExerciseId id: String, exerciseId: String, set: Int){
        let alert = UIAlertController(title: "Add Exercise Log", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "reps"
            textField.keyboardType = .decimalPad
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "weight (lbs)"
            textField.keyboardType = .decimalPad
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if let reps = alert.textFields?[0].text, reps.count > 0, let repsINT = Int(reps) {
                if let weight = alert.textFields?[1].text, weight.count > 0, let weightINT = Int(weight) {
                    API.UserExerciseLogs.createExerciseLog(withId: exerciseId, completion: {
                        logId in
                        API.WorkoutExerciseLogs.createWorkoutExerciseLog(workoutLogId: self.workoutLogId!, workoutExerciseId: id, logId: logId)
                        API.ExerciseLog.createExerciseLog(withId: logId, set: set, reps: repsINT, weight: weightINT, score: 0.0)
                    })
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    
    private func setBreak(withId id: String) {
    

        print("set break with id \(id)")
        let title = "Set Break"
        let message = "Set the break time between sets.\n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.isModalInPopover = true;
        
        let picker = UIPickerView(frame: CGRect(x: 10, y: 60, width: 250, height: 100))
        picker.tag = 0;
        picker.delegate = self;
        picker.dataSource = self;
        picker.clipsToBounds = true
        
        let confirmAction = UIAlertAction(title: "Set", style: UIAlertAction.Style.default, handler: ({
            action -> Void in
            
            let row = picker.selectedRow(inComponent: 0)
            if row > 0 {
                let breakTime = self.breakInSeconds[row - 1]
                print("break set to \(breakTime) for id: \(id)")
                API.WorkoutExercises.setBreak(workoutId: self.workoutId!, workoutExerciseId: id, breakTime: breakTime, onSuccess: {
                    _ in
                 
                    
                })
            }
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.view.addSubview(picker)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    

    }
    
}

extension ActiveWorkoutViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breakOptions.count;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breakOptions[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {
            self.selectedBreak = self.breakInSeconds[row - 1]
        }
    }
    
}
