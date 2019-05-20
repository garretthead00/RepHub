//
//  WorkoutTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 2/4/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {

    
    var exercises = [WorkoutExercise]()
    var exerciseNames = [String]()
    var workoutId : String?
    var workout : Workout? {
        didSet {
            self.refreshController()
        }
    }
    
    private let breakOptions = ["Set", "15 seconds", "30 seconds", "45 seconds", "1 minute", "1.5 minutes", "2 minutes", "2.5 minutes", "3 minutes", "5 minutes", "10 minutes", "15 minutes"]
    private let breakInSeconds = [15, 30, 45, 60, 90, 120, 150, 180, 300, 600, 900]
    private var selectedBreak = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.showEditing(sender:)))
        self.tableView.allowsSelectionDuringEditing = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    @objc func showEditing(sender: UIBarButtonItem){
        if self.tableView.isEditing {
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.saveWorkout()
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
        self.exerciseNames = []
        loadWorkoutExercises()
        
    }
    
    private func loadWorkoutExercises() {
        API.WorkoutExercises.observeWorkoutExercises(withId: self.workout!.id!, completion: {
            workoutExercise in
            API.Exercise.observeExercise(withId: workoutExercise.exerciseId!, completion: {
                exercise in
                self.exercises.append(workoutExercise)
                self.exerciseNames.append(exercise.name!)
                self.tableView.reloadData()
                API.ExerciseTarget.observeExerciseTarget(withId: workoutExercise.id!, completion: {
                    target in
                    workoutExercise.targets?.append(target)
                    self.tableView.reloadData()
                })
            })
        })
    }
    
    private func saveWorkout(){
        if let id = self.workout?.id {
            API.Workout.WORKOUT_DB_REF.child(id).updateChildValues(["name": self.workout!.name!,"description": self.workout!.description!], withCompletionBlock: {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTargetsCell", for: indexPath) as! ExerciseTargetsCell
            cell.exercise = self.exercises[indexPath.row-2]
            cell.exerciseName = self.exerciseNames[indexPath.row-2]
            cell.delegate = self
            return cell
        }
        
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 { return 236 }
        else if indexPath.row == 1 { return self.tableView.isEditing ? 44 : 0 }
        else if self.exercises[indexPath.row-2].targets != nil, let count = self.exercises[indexPath.row-2].targets?.count, count > 0 {
            return calculateRowHeight(count: count + 1)
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
            let moveExerciseName = self.exerciseNames[moveFrom]
            let moveExercise = self.exercises[moveFrom]
            self.exerciseNames.remove(at: moveFrom)
            self.exerciseNames.insert(moveExerciseName, at: moveTo)
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
            let name = self.exerciseNames[row]
            API.WorkoutExercises.removeWorkoutExercise(workoutId: self.workout!.id!, workoutExerciseId:  exerciseId, onSuccess: {
                result in
//                print("exercise removed")
                if result {
                    API.ExerciseTarget.removeAllTargets(withWorkoutExerciseId: exerciseId, onSuccess: {
                        result in
                        if result {
                            self.exercises.remove(at: row)
                            self.exerciseNames.remove(at: row)
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
            exercisesTVC.delegate = self as CreateWorkoutExerciseTypesDelegate
        }
        else if segue.identifier == "StartWorkout" {
            let activeWorkoutTVC = segue.destination as! ActiveWorkoutViewController
            activeWorkoutTVC.workoutId = self.workoutId
        }
    }


}


extension WorkoutTableViewController : ExerciseTargetsCellDelegate {
    func addSet(withId id: String, set: Int) {
        let alert = UIAlertController(title: "Input new set target", message: nil, preferredStyle: .alert)
        
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
            if let reps = alert.textFields?[0].text, reps.count > 0, let weight = alert.textFields?[1].text, weight.count > 0 {
                let repsVal = Int(reps)
                let weightVal = Double(weight)
                API.ExerciseTarget.addTarget(withWorkoutExerciseId: id, set: set, reps: repsVal!, weight: weightVal!)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    
    func promptExerciseSetMenu(cell: ExerciseTargetsCell, set: Int) {
        if let index = self.tableView.indexPath(for: cell) {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
            if self.exercises[index.row-2].targets!.count > 0 {
                let editAction = UIAlertAction(title: "Edit Set", style: .default, handler: { action in
                    let target = self.exercises[index.row-2].targets![set]
                    self.editTarget(withWorkoutExerciseId: self.exercises[index.row-2].id!, target: target, completion: {
                        results in
                        if results.count > 0 {
                            results.forEach({ result in
                                target.reps = result.0
                                target.weight = result.1
                                self.tableView.reloadData()
                            })
                        }
                    })
                    
                    
                })
                alert.addAction(editAction)
            }

            let removeAction = UIAlertAction(title: "Remove Set", style: .default, handler: { action in
                let target = self.exercises[index.row-2].targets![set]
                self.removeTarget(withWorkoutExerciseId: self.exercises[index.row-2].id!, target: target, completion: {
                    _ in
                    self.exercises[index.row-2].targets?.remove(at: set)
                    self.tableView.reloadData()
                })
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                // cancel alertcontroller
            })
    
            removeAction.setValue(UIColor.red, forKey: "titleTextColor")
            cancelAction.setValue(UIColor.darkGray, forKey: "titleTextColor")
            alert.addAction(removeAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }

    
    private func editTarget(withWorkoutExerciseId id: String, target: ExerciseTarget, completion: @escaping([(Int, Double)]) -> Void) {
        let alert = UIAlertController(title: "Edit set target", message: nil, preferredStyle: .alert)
        
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
            if let reps = alert.textFields?[0].text, reps.count > 0, let weight = alert.textFields?[1].text, weight.count > 0 {
                let repsVal = Int(reps)
                let weightVal = Double(weight)
                API.ExerciseTarget.editTarget(withWorkoutExerciseId: id, targetId: target.id!, reps: repsVal!, weight: weightVal!)
                completion([(repsVal!,weightVal!)])
            }
                
            }))
        
        self.present(alert, animated: true)
    }
    
    private func addTarget(workoutExerciseId: String, set: Int) {
        let alert = UIAlertController(title: "Input new set target", message: nil, preferredStyle: .alert)
        
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
            if let reps = alert.textFields?[0].text, reps.count > 0, let weight = alert.textFields?[1].text, weight.count > 0 {
                let repsVal = Int(reps)
                let weightVal = Double(weight)
                API.ExerciseTarget.addTarget(withWorkoutExerciseId: workoutExerciseId, set: set, reps: repsVal!, weight: weightVal!)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    private func removeTarget(withWorkoutExerciseId id: String, target: ExerciseTarget, completion: @escaping(Bool) -> Void) {
        API.ExerciseTarget.removeTarget(withWorkoutExerciseId: id, targetId: target.id!)
        completion(true)
        
    }
    
    func setBreak(withId id: String){
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
            (_) in
            
            let row = picker.selectedRow(inComponent: 0)
            if row > 0 {
                let breakTime = self.breakInSeconds[row - 1]
                print("break set to \(breakTime) for id: \(id)")
                API.WorkoutExercises.setBreak(workoutId: self.workout!.id!, workoutExerciseId: id, breakTime: breakTime, onSuccess: {
                    _ in
                    let updateExercise = self.exercises.first(where: { $0.id == id })
                    updateExercise?.breakTime = breakTime
                    self.tableView.reloadData()
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

extension WorkoutTableViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
}

extension WorkoutTableViewController : CreateWorkoutExerciseTypesDelegate {
    func addExercises(exercises: [Exercise]) {
        print("addExercises")
        // Create the workout-exercises then add the id to the newWorkout.exercises list
        for index in 0 ..< exercises.count {
            let setIndex = self.exercises.count + index
            let newExerciseForWorkoutRef = API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(self.workout!.id!).child("exercises").childByAutoId()
            newExerciseForWorkoutRef.setValue(["exerciseId": exercises[index].id!, "atIndex": setIndex], withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            
            })
        }
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


