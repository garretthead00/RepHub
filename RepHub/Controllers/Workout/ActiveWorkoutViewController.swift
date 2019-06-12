//
//  ActiveWorkoutViewController.swift
//  RepHub
//
//  Created by Garrett on 2/28/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import HealthKit

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
    private var totalRestTime = 0
    
    // Workout Timer
    private var workoutTimer = Timer()
    private var workoutDurationSeconds = 0.0
    
    // Workout Sesion
    var session = WorkoutSession()
    private var didStartWorkout = false
    private var didPauseWorkout = false
    
    var timer = Timer()
    private let breakOptions = ["Set", "15 seconds", "30 seconds", "45 seconds", "1 minute", "1.5 minutes", "2 minutes", "2.5 minutes", "3 minutes", "5 minutes", "10 minutes", "15 minutes"]
    private let breakInSeconds = [15, 30, 45, 60, 90, 120, 150, 180, 300, 600, 900]
    private let timeOptions = ["--", "s","min","hr"]
    private var selectedBreak = 0
    private var logAlertOption = ""
    private var breakTimeClock : Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.refreshController()
        print("starting workout...")
        self.startWorkout()
        
    }
    private func refreshController() {
        self.exercises = []
        loadWorkoutExercises()
    }
    
    // Actions
    @IBAction func additionalBreakButton_TouchUpInside(_ sender: Any) {
        self.startAdditionalBreak()
    }
    
    @IBAction func endWorkoutButton_TouchUpInside(_ sender: Any) {
        self.endWorkout()
    }
    
    private func startWorkout() {
        if didStartWorkout {
            return
        }
        session.start()
        self.workoutTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
    }
    
    private func endWorkout() {
        session.end()
        self.totalSteps = session.steps
        self.workoutTimer.invalidate()
        self.performSegue(withIdentifier: "WorkoutResults", sender: nil)
    }
    
    private func startAdditionalBreak() {
        var breakCount = 0
        let alert = UIAlertController(title: "", message: "\n\n\n", preferredStyle: .alert)
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 1
        subview.backgroundColor = UIColor.darkText
        subview.layer.borderColor = UIColor.lightGray.cgColor
        subview.layer.borderWidth = 1
        let attributedString = NSAttributedString(string: "Additional Break", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.Theme.aqua ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        let countdownLabel = UILabel(frame: CGRect(x: 10, y: 32, width: 250, height: 100))
        countdownLabel.textAlignment = .center
        countdownLabel.clipsToBounds = true
        countdownLabel.font = UIFont(name:"Chalkduster", size: 24.0)
        countdownLabel.textColor = UIColor.Theme.aqua
        countdownLabel.text = "0 s"
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){
            _ in
            print("Timer fired! \(self.breakTimeClock) s")
            breakCount += 1
            countdownLabel.text = "\(breakCount) s"
        }
        
        alert.view.addSubview(countdownLabel)
        alert.addAction(UIAlertAction(title: "Stop", style: .cancel, handler: ({
            action -> Void in
            self.totalRestTime += breakCount
            self.timer.invalidate()
            print("totalRestTime: \(self.totalRestTime)")
        })))
        self.present(alert, animated: true)
    }
    

    private func loadWorkoutExercises() {
        API.Workout.observerExercisesForWorkout(withId: self.workoutId!, completion: {
            workoutExercise in
            print("workoutExercise")
            print(workoutExercise)
            API.Exercise.observeExercise(withId: workoutExercise.exerciseId!, completion: {
                exercise in
                print("exercises")
                print(exercise)
                workoutExercise.name = exercise.name!
                workoutExercise.metricType = exercise.metricType!
                self.exercises.append(workoutExercise)
                self.tableview.reloadData()
            })
        })
    }
    
    private func createNewWorkoutLog(){
        guard let currentUserId = API.RepHubUser.CURRENT_USER?.uid else {
            return
        }
        API.UserWorkoutLogs.createUserWorkoutLog(withUserId: currentUserId, workoutId: self.workoutId!, completion: {
            key in
            print("workoutID: \(key)")
            self.workoutLogId = key
        })
    }

    @objc private func updateView() {
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
    
    private func dismissAndRefreshWorkouts() {
        session.clear()
        self.workoutDurationSeconds = 0
        self.didStartWorkout = false
        self.totalWork = 0.0
        self.totalReps = 0
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "WorkoutResults" {
             let destinationCtrl = segue.destination as! WorkoutResultsTableViewController
             destinationCtrl.totalWork = self.totalWork
             destinationCtrl.totalReps = self.totalReps
             destinationCtrl.totalSteps = self.totalSteps
             destinationCtrl.caloriesBurned = self.caloriesBurned
             destinationCtrl.totalDistance = self.totalDistance
             destinationCtrl.workoutDurationSeconds = self.workoutDurationSeconds
             destinationCtrl.exercises = self.exercises
            if let currentWorkout = self.session.completeWorkout {
                destinationCtrl.workout = currentWorkout
            }
         }
     }
}

extension ActiveWorkoutViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveExerciseTargetsTableViewCell", for: indexPath) as! ActiveExerciseTargetsTableViewCell
        cell.exercise = self.exercises[indexPath.row]
        cell.countdown = self.exercises[indexPath.row].breakTime
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let count = self.exercises[indexPath.row].sets, count > 0 {
            return calculateRowHeight(count: count)
        }
        else {
            return calculateRowHeight(count: 1)
        }
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
    
    func startBreak(countdown: Int) {
        logAlertOption = "Break"
        if countdown > 0 {
            startBreakTimer(countdown: countdown)
        } else {
            setBreak()
        }
    }
    
    private func startBreakTimer(countdown: Int) {
        self.breakTimeClock = countdown

        let alert = UIAlertController(title: "", message: "\n\n\n", preferredStyle: .alert)
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 1
        subview.backgroundColor = UIColor.darkText
        subview.layer.borderColor = UIColor.lightGray.cgColor
        subview.layer.borderWidth = 1
        let attributedString = NSAttributedString(string: "Break", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.Theme.aqua ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        let countdownLabel = UILabel(frame: CGRect(x: 10, y: 32, width: 250, height: 100))
        countdownLabel.textAlignment = .center
        countdownLabel.clipsToBounds = true
        countdownLabel.font = UIFont(name:"Chalkduster", size: 24.0)
        countdownLabel.textColor = UIColor.Theme.aqua
        countdownLabel.text = "\(self.breakTimeClock) s"
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){
            _ in
            print("Timer fired! \(self.breakTimeClock) s")
            self.breakTimeClock -= 1
            countdownLabel.text = "\(self.breakTimeClock) s"
            if self.breakTimeClock == 0 {
                self.timer.invalidate()
                print("totalRestTime: \(self.totalRestTime)")
            }
        }
        
        alert.view.addSubview(countdownLabel)
        alert.addAction(UIAlertAction(title: "Stop", style: .cancel, handler: ({
            action -> Void in
            if self.breakTimeClock == 0 {
                self.totalRestTime += countdown
            } else {
                self.totalRestTime += (countdown - self.breakTimeClock)
            }
            
            self.timer.invalidate()
            print("totalRestTime: \(self.totalRestTime)")
        })))
        self.present(alert, animated: true)
    }

    
    func addAdditionalExerciseLog(withWorkoutExerciseId id: String, exerciseId: String, set: Int) {
        print("add additional exercise log to workoutExerciseId \(id) for set \(set) of exerciseId \(exerciseId)")
        promptExerciseLogMenu(withWorkoutExerciseId: id, exerciseId: exerciseId, set: set)
    }
    
    func addExerciseLog(withWorkoutExerciseId id: String, exerciseId: String, set: Int) {
        print("add exercise log to workoutExerciseId \(id) for set \(set) of exerciseId \(exerciseId)")
        if let index = self.exercises.firstIndex(where: {$0.id == id}) {
            let metricType = self.exercises[index].metricType
            logAlertOption = metricType!
            if metricType == "Time" {
                promptTimeInputMenu(withWorkoutExerciseId: id, exerciseId: exerciseId, set: set)
            } else if metricType == "Distance" {
                promptDistanceInputMenu(withWorkoutExerciseId: id, exerciseId: exerciseId, set: set)
            } else {
                promptExerciseLogMenu(withWorkoutExerciseId: id, exerciseId: exerciseId, set: set)
            }
        }
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
                if let weight = alert.textFields?[1].text, weight.count > 0, let weightDBL = Double(weight) {
                    if let index = self.exercises.firstIndex(where: {$0.id == id}) {
                        let newLog = ExerciseLog()
                        newLog.set = set
                        newLog.value = repsINT
                        newLog.weightLB = weightDBL
                        newLog.metricUnit = self.exercises[index].metricUnit
                        let score = (Double(newLog.value!) / Double(self.exercises[index].target!)) * 100.0
                        newLog.score = score
                        print("...log score: \(score)")
                        self.exercises[index].logs?.append(newLog)
                        self.tableview.reloadData()
                    }
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    private func promptTimeInputMenu(withWorkoutExerciseId id: String, exerciseId: String, set: Int) {
        var exercise : WorkoutExercise?
        if let index = self.exercises.firstIndex(where: {$0.id == id}) {
            exercise = self.exercises[index]
            let metricUnit = exercise?.metricUnit
            let alert = UIAlertController(title: "Input Time", message: "\(metricUnit!)\n", preferredStyle: .alert)
            let picker = UIPickerView(frame: CGRect(x: 10, y: 100, width: 250, height: 100))
            picker.tag = 0;
            picker.delegate = self;
            picker.dataSource = self;
            picker.clipsToBounds = true
            alert.view.addSubview(picker)
            
            let confirmAction = UIAlertAction(title: "Set", style: UIAlertAction.Style.default, handler: ({
                (_) in
                let targetSelectionRow = picker.selectedRow(inComponent: 0)
                if targetSelectionRow > 0 {
                    let targetVal = targetSelectionRow
                    let newLog = ExerciseLog()
                    newLog.set = set
                    newLog.value = targetVal
                    newLog.weightLB = 0.0
                    newLog.metricUnit = self.exercises[index].metricUnit
                    let score = (Double(newLog.value!) / Double(self.exercises[index].target!)) * 100.0
                    newLog.score = score
                    print("...log score: \(score)")
                    self.exercises[index].logs?.append(newLog)
                    self.tableview.reloadData()
                }
            }))
            
            alert.addAction(confirmAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 248.0)
            alert.view.addConstraint(height)
            self.present(alert, animated: true)
        }
    }
    
    private func promptDistanceInputMenu(withWorkoutExerciseId id: String, exerciseId: String, set: Int){
        var exercise : WorkoutExercise?
        if let index = self.exercises.firstIndex(where: {$0.id == id}) {
            exercise = self.exercises[index]
            let metricUnit = exercise?.metricUnit
            let alert = UIAlertController(title: "Add Distance Log", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "\(metricUnit!)"
                textField.keyboardType = .decimalPad
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                if let distance = alert.textFields?[0].text, distance.count > 0, let distanceINT = Int(distance) {
                    let newLog = ExerciseLog()
                    newLog.set = set
                    newLog.value = distanceINT
                    newLog.weightLB = 0.0
                    newLog.metricUnit = self.exercises[index].metricUnit
                    let score = (Double(newLog.value!) / Double(self.exercises[index].target!)) * 100.0
                    newLog.score = score
                    print("...log score: \(score)")
                    self.exercises[index].logs?.append(newLog)
                    self.tableview.reloadData()
                }
                
            }))
            self.present(alert, animated: true)
        }

    }
    
    private func setBreak() {
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
                self.startBreakTimer(countdown: breakTime)
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
        let values = Array(0...60)
        if logAlertOption == "Time" {
            return values.count
        } else if logAlertOption == "Break" {
            return breakOptions.count
        } else {
            return 1;
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if logAlertOption == "Time" {
            return 1
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var values = Array(0...60)
        if logAlertOption == "Time" {
            return "\(values[row])"
        } else {
            return breakOptions[row]
        }
    }
}
