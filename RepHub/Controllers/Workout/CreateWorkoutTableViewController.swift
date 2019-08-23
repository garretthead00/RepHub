//
//  CreateWorkoutTableViewController.swift
//  FirebaseAuth
//
//  Created by Garrett Head on 5/25/19.
//

import UIKit



class CreateWorkoutTableViewController: UITableViewController {
    
    
    var workoutName = ""
    var workoutDescription = ""
    var exercises = [WorkoutExercise]()
    
    private var selectedBreak = 0
    private let breakOptions = ["Set", "15 seconds", "30 seconds", "45 seconds", "1 minute", "1.5 minutes", "2 minutes", "2.5 minutes", "3 minutes", "5 minutes", "10 minutes", "15 minutes"]
    private let distanceOptions = ["--", "m","yd","mi","km"]
    private let timeOptions = ["--", "s","min","hr"]
    private let breakInSeconds = [15, 30, 45, 60, 90, 120, 150, 180, 300, 600, 900]
    private var targetAlertOption = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        print("saveButton_TouchUpInside...")
        if !self.workoutName.isEmpty {
            if !self.workoutDescription.isEmpty {
                print("createWorkout...")
                print("name: \(self.workoutName)")
                print("desc: \(self.workoutDescription)")
                self.createWorkout(name: self.workoutName, description: self.workoutDescription)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count + 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutDetails", for: indexPath) as! CreateWorkoutDetailsTableViewCell
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddExercise", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise", for: indexPath) as! Workout_ExerciseTableViewCell
            let index = indexPath.row - 2
            cell.exercise = self.exercises[index]
            if let sets = self.exercises[index].sets, sets > 0 , let target = self.exercises[index].target, target > 0 {
                if let unit = self.exercises[index].metricUnit {
                    if unit != "Repitition" {
                        cell.targetString = "\(sets) x \(target) \(unit)"
                    }
                    else {
                        cell.targetString = "\(sets) x \(target)"
                        
                    }
                }
                
            }
            if let breakTime = self.exercises[indexPath.row - 2].breakTime, breakTime > 0 {
                cell.breakString = "\(breakTime)"
            }
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        else if indexPath.row == 1 {
            return 44
        }
        else {
            return 76
        }
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.exercises.remove(at: indexPath.row - 2)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExercise" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let exercisesTVC = destinationNavigationController.topViewController as! CreateWorkout_ExerciseTypesCollectionViewController
            exercisesTVC.delegate = self
        }
    }
 
    
    
    
    private func createWorkout(name: String, description: String){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        print("saving workout...")
        let newWorkoutRef = API.Workout.WORKOUT_DB_REF.child(currentUser.uid).childByAutoId()
        newWorkoutRef.setValue(["name" : name, "description" : description], withCompletionBlock: {
            error, ref in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            print("saved workout!")
            print("saving \(self.exercises.count) exercises")
            // Create the workout-exercises then add the id to the newWorkout.exercises list
            for (index, exercise) in self.exercises.enumerated() {
                print("im in!")
                print("exerciseId: \(self.exercises[index].exerciseId!),")
                print("atIndex: \(index),")
                print("sets: \(self.exercises[index].sets!),")
                print("target: \(self.exercises[index].target!),")
                print("breakTime: \(self.exercises[index].breakTime!),")
                print("metricUnit: \(self.exercises[index].metricUnit)")
                let newExerciseForWorkoutRef = API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(newWorkoutRef.key!).child("exercises").childByAutoId()
                newExerciseForWorkoutRef.setValue(["exerciseId": self.exercises[index].exerciseId!, "atIndex": index, "sets": self.exercises[index].sets!, "target": self.exercises[index].target!, "breakTime": self.exercises[index].breakTime!, "metricUnit": self.exercises[index].metricUnit], withCompletionBlock: {
                    error, ref in
                    if error != nil {
                        ProgressHUD.showError(error!.localizedDescription)
                        return
                    }
                })
            }
            
        })
    }
    
    

}

extension CreateWorkoutTableViewController : WorkoutExerciseTypesDelegate {
    func addExercises(exercises: [Exercise]) {
        print("added exercises")
        for exercise in exercises {
            let newWorkoutExercise = WorkoutExercise()
            newWorkoutExercise.exerciseId = exercise.id
            newWorkoutExercise.name = exercise.name
            newWorkoutExercise.sets = 0
            newWorkoutExercise.target = 0
            newWorkoutExercise.breakTime = 0
            newWorkoutExercise.metricType = exercise.metricType
            newWorkoutExercise.metricUnit = ""
            self.exercises.append(newWorkoutExercise)
            self.tableView.reloadData()
        }
        
    }
    
    
}

extension CreateWorkoutTableViewController : Workout_ExerciseDelegate {
    
    func setTarget(cell: Workout_ExerciseTableViewCell) {
        if let index = self.tableView.indexPath(for: cell)?.row {
            let exerciseIndex = index - 2
            targetAlertOption = self.exercises[exerciseIndex].metricType!
            print("setting Target at index")
            print("\(self.exercises[exerciseIndex].metricType!)")
            if targetAlertOption == "Distance" {
                promptDistanceBasedAlertController(exerciseIndex: exerciseIndex)
            } else if targetAlertOption == "Time" {
                promptTimeBasedAlertController(exerciseIndex: exerciseIndex)
            } else {
                promptRepBasedAlertController(exerciseIndex: exerciseIndex)
            }
            
            
        }
        
        
    }
    
    func setBreak(cell: Workout_ExerciseTableViewCell) {
        print("setting Break")
        if let index = self.tableView.indexPath(for: cell)?.row  {
            targetAlertOption = "Break"
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
                (_) in
                let row = picker.selectedRow(inComponent: 0)
                if row > 0 {
                    let breakTime = self.breakInSeconds[row - 1]
                    print("break set to \(breakTime)")
                    let idx = index - 2
                    self.exercises[idx].breakTime = breakTime
                    self.tableView.reloadData()
                }
            }))
            
            alert.view.addSubview(picker)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(confirmAction)
            
            self.present(alert, animated: true)
        }
    }
    
    private func promptRepBasedAlertController(exerciseIndex: Int){
        let alert = UIAlertController(title: "Input target", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "sets"
            textField.keyboardType = .decimalPad
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "reps"
            textField.keyboardType = .decimalPad
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if let set = alert.textFields?[0].text, set.count > 0, let target = alert.textFields?[1].text, target.count > 0 {
                let targetVal = Int(target)
                let setVal = Int(set)
                self.exercises[exerciseIndex].sets = setVal!
                self.exercises[exerciseIndex].target = targetVal!
                self.exercises[exerciseIndex].metricUnit = "Repitition"
                self.tableView.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    
    private func promptDistanceBasedAlertController(exerciseIndex: Int){
        let alert = UIAlertController(title: "Input target", message: "\n", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "sets"
            textField.keyboardType = .decimalPad
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "distance"
            textField.keyboardType = .decimalPad
        })
        let picker = UIPickerView(frame: CGRect(x: 10, y: 120, width: 250, height: 80))
        picker.tag = 0;
        picker.delegate = self;
        picker.dataSource = self;
        picker.clipsToBounds = true
        alert.view.addSubview(picker)
        
        let confirmAction = UIAlertAction(title: "Set", style: UIAlertAction.Style.default, handler: ({
            (_) in
            if let set = alert.textFields?[0].text, set.count > 0, let target = alert.textFields?[1].text, target.count > 0 {
                let targetVal = Int(target)
                let setVal = Int(set)
                let row = picker.selectedRow(inComponent: 0)
                if row > 0 {
                    let distanceSelection = self.distanceOptions[row]
                    self.exercises[exerciseIndex].sets = setVal!
                    self.exercises[exerciseIndex].target = targetVal!
                    self.exercises[exerciseIndex].metricUnit = distanceSelection
                    self.tableView.reloadData()
                }
            }
            
        }))
        
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 248.0)
        alert.view.addConstraint(height)
        self.present(alert, animated: true)
    }
    
    private func promptTimeBasedAlertController(exerciseIndex: Int){
        let alert = UIAlertController(title: "Input target", message: "\n", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "sets"
            textField.keyboardType = .decimalPad
        })
        
        let picker = UIPickerView(frame: CGRect(x: 10, y: 100, width: 250, height: 100))
        picker.tag = 0;
        picker.delegate = self;
        picker.dataSource = self;
        picker.clipsToBounds = true
        alert.view.addSubview(picker)
        
        let confirmAction = UIAlertAction(title: "Set", style: UIAlertAction.Style.default, handler: ({
            (_) in
            if let set = alert.textFields?[0].text, set.count > 0 {
                let setVal = Int(set)
                let targetSelectionRow = picker.selectedRow(inComponent: 0)
                let timeSelectionRow = picker.selectedRow(inComponent: 1)
                if targetSelectionRow > 0 && timeSelectionRow > 0 {
                    let timeVal = self.timeOptions[timeSelectionRow]
                    let targetVal = targetSelectionRow
                    self.exercises[exerciseIndex].sets = setVal!
                    self.exercises[exerciseIndex].target = targetVal
                    self.exercises[exerciseIndex].metricUnit = timeVal
                    self.tableView.reloadData()
                }
            }
            
        }))
        
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 248.0)
        alert.view.addConstraint(height)
        self.present(alert, animated: true)
    }
    
    
}

extension CreateWorkoutTableViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var values = Array(0...60)
        if targetAlertOption == "Time" {
            if component == 0 {
                return values.count;
            } else {
                return timeOptions.count;
            }
        } else if targetAlertOption == "Distance" {
            return distanceOptions.count
        } else if targetAlertOption == "Break" {
            return breakOptions.count
        } else {
            return 1;
        }
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if targetAlertOption == "Time" {
            return 2
        } else if targetAlertOption == "Distance" {
            return 1
        } else if targetAlertOption == "Break" {
            return 1
        } else {
            return 1
        }
        
    }
    
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var values = Array(0...60)
        if targetAlertOption == "Time" {
            if component == 0 {
                return "\(values[row])"
            } else {
                return timeOptions[row]
            }
        } else if targetAlertOption == "Distance" {
            return distanceOptions[row]
        } else if targetAlertOption == "Break" {
            return breakOptions[row]
        } else {
            return distanceOptions[row]
        }
        
    }
    
}

extension CreateWorkoutTableViewController : CreateWorkoutDetailsDelegate {
    func updateName(name: String) {
        print("giving name: \(name)")
        self.workoutName = name
    }

    func updateDescription(description: String) {
        print("giving description: \(description)")
        self.workoutDescription = description
        //self.tableview.reloadData()
    }

}


