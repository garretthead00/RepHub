//
//  WorkoutViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/27/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit


class WorkoutViewController: UIViewController {

    // Outlets from Scene
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var startWorkoutButton: UIButton!
    @IBOutlet weak var editControlsStackView: UIStackView!
    
    var exercises = [WorkoutExercise]()
    var exerciseNames = [String]()
    var exercisesForWorkout = [String]()
    var workoutId : String?
    var workout = Workout()
    private let breakOptions = ["15 seconds", "30 seconds", "45 seconds", "1 minute", "1.5 minutes", "2 minutes", "2.5 minutes", "3 minutes", "5 minutes", "10 minutes", "15 minutes"]
    private var selectedBreak = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.showEditing(sender:)))
        self.loadWorkout()
        self.editControlsStackView.isHidden = true

    }

    private func loadWorkout(){
        API.Workout.observeWorkout(withId: self.workoutId!, completion: {
            workout in
            self.workout = workout
            self.navigationItem.title = self.workout.name
            API.WorkoutExercises.observeWorkoutExercises(withId: workout.id!, completion: {
                workoutExercise in
                API.Exercise.observeExercise(withId: workoutExercise.exerciseId!, completion: {
                    exercise in
                    self.exerciseNames.append(exercise.name!)
                    self.exercises.append(workoutExercise)
                    self.tableview.reloadData()
                })
            })
        })
        print("Hello World!!")
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
                self.tableview.reloadData()
            })
        })
    }
    
    private func loadNewExercises(){
        for newExercise in self.exercisesForWorkout {
            let newExerciseForWorkoutRef = API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(self.workoutId!).childByAutoId()
            newExerciseForWorkoutRef.setValue(["exerciseId": newExercise], withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
        }
    }
    
    private lazy var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    

    @objc func showEditing(sender: UIBarButtonItem)
    {
        if(self.tableview.isEditing == true)
        {
            self.tableview.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.startWorkoutButton.isHidden = false
            self.editControlsStackView.isHidden = true
            self.saveWorkout(onSuccess: {
                self.exercisesForWorkout.removeAll()
            })
        }
        else
        {
            self.tableview.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Save"
            self.startWorkoutButton.isHidden = true
            self.editControlsStackView.isHidden = false
        }
    }
    
    private func saveWorkout(onSuccess: @escaping() -> Void){
        if let name = self.workout.name, !name.isEmpty {
            let description = self.workout.description
            API.Workout.WORKOUT_DB_REF.child(self.workoutId!).setValue(["name" : name, "description" : description], withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                for index in 0 ..< self.exercises.count {
                    if let id = self.exercises[index].id {
                        API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(self.workoutId!).child(id).updateChildValues(["atIndex": index])
                    }
                }
            })
        } else {
            ProgressHUD.showError("Name missing!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExercise" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let exercisesTVC = destinationNavigationController.topViewController as! ExerciseTypesForWorkoutTableViewController
            exercisesTVC.delegate = self
        }
        else if segue.identifier == "StartWorkout" {
            let activeWorkoutTVC = segue.destination as! ActiveWorkoutTableViewController
            activeWorkoutTVC.workoutId = self.workoutId
        }
    }

}

extension WorkoutViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.exercises[indexPath.row].exerciseId!
        self.performSegue(withIdentifier: "ExerciseLog", sender: id)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.exercises[sourceIndexPath.row]
        exercises.remove(at: sourceIndexPath.row)
        exercises.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = self.exercises[indexPath.row].id!
            API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(self.workoutId!).child(id).removeValue(completionBlock: {
                error, ref in
                self.exercises.remove(at: indexPath.row)
                self.tableview.deleteRows(at: [indexPath], with: .fade)
            })
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let breakAction = UIContextualAction(style: .normal, title:  nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let title = "Break"
            let message = "Set the break time limit between sets.\n\n\n\n\n";
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.isModalInPopover = true;

            let picker = UIPickerView(frame: CGRect(x: 10, y: 60, width: 250, height: 100))
            picker.tag = 0;
            picker.delegate = self;
            picker.dataSource = self;
            
            let confirmAction = UIAlertAction(title: "Set", style: UIAlertAction.Style.default, handler: ({
                (_) in
                let updateExerciseForWorkoutRef = API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(self.workoutId!).child(self.exercises[indexPath.row].id!)
                updateExerciseForWorkoutRef.updateChildValues(["breakTime":self.selectedBreak], withCompletionBlock: {
                    error, ref in
                    if error != nil {
                        ProgressHUD.showError(error!.localizedDescription)
                        return
                    }
                    self.exercises[indexPath.row].breakTime = self.selectedBreak
                    self.tableview.reloadData()
                })
                
            }))
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            alert.view.addSubview(picker)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)
            success(true)
        })
        
        breakAction.image = UIImage(named: "timer.png")
        breakAction.backgroundColor = UIColor.lightGray
        
        let targetAction = UIContextualAction(style: .normal, title:  nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alertController = UIAlertController(title: "Set Targets", message: "Add targets for this exercise.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default, handler: ({
                (_) in
                if let setsField = alertController.textFields![0] as? UITextField, let repsField = alertController.textFields![1] as? UITextField  {
                    let updateExerciseForWorkoutRef = API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(self.workoutId!).child(self.exercises[indexPath.row].id!)
                    let sets = Int(setsField.text!) ?? 0
                    let reps = Int(repsField.text!) ?? 0
                    updateExerciseForWorkoutRef.updateChildValues(["targetSets":sets, "targetReps": reps], withCompletionBlock: {
                        error, ref in
                        if error != nil {
                            ProgressHUD.showError(error!.localizedDescription)
                            return
                        }
                        self.exercises[indexPath.row].targetReps = reps
                        self.exercises[indexPath.row].targetSets = sets
                        self.tableview.reloadData()
                    })
                }
            }))
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addTextField(configurationHandler: {
                (textField) in
                textField.placeholder = "sets"
            })
            
            alertController.addTextField(configurationHandler: {
                (textField) in
                textField.placeholder = "reps"
            })
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            success(true)
        })
        
        targetAction.image = UIImage(named: "target.png")
        targetAction.backgroundColor = UIColor.green

        let addLogAction = UIContextualAction(style: .normal, title:  nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let id = self.exercises[indexPath.row].exerciseId!
            self.performSegue(withIdentifier: "ExerciseLog", sender: id)
            success(true)
        })
        addLogAction.image = UIImage(named: "pencil.png")
        addLogAction.backgroundColor = UIColor.blue
        return UISwipeActionsConfiguration(actions: [addLogAction, targetAction, breakAction])
    }

}

extension WorkoutViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        selectedBreak = breakOptions[row]
    }
}

extension WorkoutViewController : CreateWorkout_ExerciseTypesForWorkoutDelegate {
    func addExercisesForWorkout(exercisesToBeAdded: [String]) -> [String] {
        self.exercisesForWorkout.removeAll()
        self.exercisesForWorkout.append(contentsOf: exercisesToBeAdded)
        self.loadNewExercises()
        return self.exercisesForWorkout
    }
}


