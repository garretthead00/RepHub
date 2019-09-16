//
//  WorkoutTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 2/4/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol WorkoutDelegate {
    func refreshWorkouts()
}

class WorkoutTableViewController: UITableViewController {

    var delegate : WorkoutDelegate?
    var exercises = [WorkoutExercise]()
    var workoutId : String?
    var workout : Workout?
    
    private let breakOptions = ["Set", "15 seconds", "30 seconds", "45 seconds", "1 minute", "1.5 minutes", "2 minutes", "2.5 minutes", "3 minutes", "5 minutes", "10 minutes", "15 minutes"]
    private let distanceOptions = ["--", "m","yd","mi","km"]
    private let timeOptions = ["--", "s","min","hr"]
    private let breakInSeconds = [15, 30, 45, 60, 90, 120, 150, 180, 300, 600, 900]
    private var selectedBreak = 0
    private var targetAlertOption = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.showEditing(sender:)))
        self.tableView.allowsSelectionDuringEditing = true
        loadWorkoutExercises()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    @objc func showEditing(sender: UIBarButtonItem){
        if self.tableView.isEditing {
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.saveWorkout()
            self.delegate?.refreshWorkouts()
            self.tableView.reloadData()
        }
        else
        {
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Save"
            self.tableView.reloadData()
        }
    }
    
    private func refreshController(){
        self.exercises = []
        loadWorkoutExercises()
        
    }
    
    private func loadWorkoutExercises() {
        API.Workout.observerExercisesForWorkout(withId: self.workout!.id!, completion: {
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
                self.tableView.reloadData()
            })
        })
    }
    
    private func saveWorkout(){

        if let id = self.workout?.id {
            guard let currentUser = API.RepHubUser.CURRENT_USER else {
                return
            }
            print("saving workout for user: \(currentUser.uid) workoutId: \(id) name: \(self.workout!.name!) desc: \(self.workout!.description!)")
            API.Workout.WORKOUT_DB_REF.child(currentUser.uid).child(id).updateChildValues(["name": self.workout!.name!,"description": self.workout!.description!], withCompletionBlock: {
                err, ref in
                
                if err != nil {
                    return
                }
                print("saved")
                var i = 0
                for exercise in self.exercises {
                    print("exercise: \(exercise.id) index: \(i)")
                API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").child(exercise.id!).updateChildValues(["atIndex": i], withCompletionBlock: {
                        err, ref in
                        if err != nil {
                            return
                        }
                    })
                    i += 1
                }

            })
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutControlsTableViewCell", for: indexPath) as! WorkoutControlsTableViewCell
            cell.delegate = self
            
            if let name = self.workout?.name, !name.isEmpty {
                cell.nameTextField.text = self.workout?.name
            }
            if let desc = self.workout?.description, !desc.isEmpty {
                 cell.descriptionTextView.text = desc
            }
            
            if self.tableView.isEditing {
                cell.nameTextField.isEnabled = true
                cell.descriptionTextView.isEditable = true
            } else {
                cell.nameTextField.isEnabled = false
                cell.descriptionTextView.isEditable = false
            }
            
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddExerciseCell", for: indexPath)
            if self.tableView.isEditing {
                cell.isHidden = false
            } else {
                cell.isHidden = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise", for: indexPath) as! Workout_ExerciseTableViewCell
            cell.exercise = self.exercises[indexPath.row - 2]
            if let sets = self.exercises[indexPath.row - 2].sets, sets > 0 , let target = self.exercises[indexPath.row - 2].target, target > 0 {
                if let unit = self.exercises[indexPath.row - 2].metricUnit {
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
        if indexPath.row == 0 { return 236 }
        else if indexPath.row == 1 {
            if self.tableView.isEditing {
                return 44
            } else {
                return 0
            }
        }
        else { return 76 }
        
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
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row <= 1 ? false : true
    }
 
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row <= 1 ? false : true
    }
    
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var moveFrom = sourceIndexPath.row
        var moveTo = destinationIndexPath.row

        if moveFrom >= 2, moveTo >= 2 {
            moveFrom -= 2
            moveTo -= 2
            let moveExercise = self.exercises[moveFrom]
            self.exercises.remove(at: moveFrom)
            self.exercises.insert(moveExercise, at: moveTo)
        }
        
    }
    
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var row = indexPath.row
        row -= 2
        if editingStyle == .delete {
            let exerciseId = self.exercises[row].id!
            API.WorkoutExercises.removeWorkoutExercise(workoutId: self.workout!.id!, workoutExerciseId:  exerciseId, onSuccess: {
                result in
                if result {
                    API.ExerciseTarget.removeAllTargets(withWorkoutExerciseId: exerciseId, onSuccess: {
                        result in
                        if result {
                            self.exercises.remove(at: row)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                        
                        }
                    })
                }
            })
        } else if editingStyle == .insert {
//            print("----WokroutTVC -- inserted tvcell")
        }
    }
        


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExercise" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let exercisesTVC = destinationNavigationController.topViewController as! CreateWorkout_ExerciseTypesCollectionViewController
            exercisesTVC.delegate = self as WorkoutExerciseTypesDelegate
        }
        else if segue.identifier == "StartWorkout" {
            let activeWorkoutTVC = segue.destination as! ActiveWorkoutViewController
            activeWorkoutTVC.workoutId = self.workoutId
        }
    }


}




extension WorkoutTableViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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

extension WorkoutTableViewController : WorkoutExerciseTypesDelegate {
    func addExercises(exercises: [Exercise]) {
        print("addExercises")
        for index in 0 ..< exercises.count {
            let newExerciseRef = API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(self.workout!.id!).child("exercises").childByAutoId()
            newExerciseRef.setValue(["exerciseId": exercises[index].id!, "atIndex": index, "sets": 0, "target": 0, "breakTime": 0, "metricUnit": ""], withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
        }
        self.tableView.reloadData()
    }
}

extension WorkoutTableViewController : WorkoutControlsDelegate {
    func updateDescription(description: String) {
        self.workout?.description = description
    }
    
    func updateName(name: String) {
        self.workout?.name = name
    }
    
    func startWorkout() {
        print("startWorkout")
        performSegue(withIdentifier: "StartWorkout", sender: nil)
    }
}

extension WorkoutTableViewController : Workout_ExerciseDelegate {
    func setTarget(cell: Workout_ExerciseTableViewCell) {
        if let index = self.tableView.indexPath(for: cell)?.row {
            targetAlertOption = self.exercises[index - 2].metricType!
            print("setting Target at index")
            print("\(self.exercises[index - 2].metricType!)")
            let exerciseIndex = index - 2
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
                    if let id = self.workout?.id {
                        API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").child(self.exercises[idx].id!).updateChildValues(["breakTime": breakTime], withCompletionBlock: {
                            err, ref in
                            if err != nil {
                                return
                            }
                            self.exercises[idx].breakTime = breakTime
                            self.tableView.reloadData()
                        })
                        
                    }
                    
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
                if let id = self.workout?.id {
                    API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").child(self.exercises[exerciseIndex].id!).updateChildValues(["sets": setVal!, "target": targetVal, "metricUnit": "Repitition"], withCompletionBlock: {
                        err, ref in
                        if err != nil {
                        return
                        }
                        self.exercises[exerciseIndex].sets = setVal!
                        self.exercises[exerciseIndex].target = targetVal!
                        self.exercises[exerciseIndex].metricUnit = "Repitition"
                        self.tableView.reloadData()
                    })

                }
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
                if let id = self.workout?.id {
                    let targetVal = Int(target)
                    let setVal = Int(set)
                    let row = picker.selectedRow(inComponent: 0)
                    if row > 0 {
                        let distanceSelection = self.distanceOptions[row]
                        API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").child(self.exercises[exerciseIndex].id!).updateChildValues(["sets": setVal!, "target": targetVal, "metricUnit": distanceSelection], withCompletionBlock: {
                            err, ref in
                            if err != nil {
                                return
                            }
                            self.exercises[exerciseIndex].sets = setVal!
                            self.exercises[exerciseIndex].target = targetVal!
                            self.exercises[exerciseIndex].metricUnit = distanceSelection
                            self.tableView.reloadData()
                        })
                    }
                    
                }
            }
            
        }))
        
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 248.0)
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
                if let id = self.workout?.id {
                    let setVal = Int(set)
                    let targetSelectionRow = picker.selectedRow(inComponent: 0)
                    let timeSelectionRow = picker.selectedRow(inComponent: 1)
                    if targetSelectionRow > 0 && timeSelectionRow > 0 {
                        let timeVal = self.timeOptions[timeSelectionRow]
                        let targetVal = targetSelectionRow
                        API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(id).child("exercises").child(self.exercises[exerciseIndex].id!).updateChildValues(["sets": setVal!, "target": targetVal, "metricUnit": timeVal], withCompletionBlock: {
                            err, ref in
                            if err != nil {
                                return
                            }
                            self.exercises[exerciseIndex].sets = setVal!
                            self.exercises[exerciseIndex].target = targetVal
                            self.exercises[exerciseIndex].metricUnit = timeVal
                            self.tableView.reloadData()
                        })
                    }
                    
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



