//
//  CreateWorkoutViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/16/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class CreateWorkoutViewController: UIViewController {

 
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    var exercises = [Exercise]()
    var exercisesForWorkout = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cancelButton.addTarget(self, action: #selector(cancelCreateWorkout), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveWorkout), for: .touchUpInside)
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }

    @objc private func saveWorkout(){

        let index = IndexPath(row: 0, section: 0)
        let cell = tableview.cellForRow(at: index) as! CreateWorkoutDetailsTableViewCell
        let description = cell.workoutDescriptionTextView.text
        let newWorkoutRef = API.Workout.WORKOUT_DB_REF.childByAutoId()
        if let name = cell.workoutNameTextField.text, !name.isEmpty {
            // Create a new workout
            newWorkoutRef.setValue(["name" : name, "description" : description], withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                print("saved workout!")

                // Create the workout-exercises then add the id to the newWorkout.exercises list
                for index in 0 ..< self.exercises.count {
                    let newExerciseForWorkoutRef = API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(newWorkoutRef.key).child("exercises").childByAutoId()
                    newExerciseForWorkoutRef.setValue(["exerciseId": self.exercises[index].id!, "atIndex": index], withCompletionBlock: {
                        error, ref in
                        if error != nil {
                            ProgressHUD.showError(error!.localizedDescription)
                            return
                        }
                    })
                }
                
            })
            
            // Create a new user-workout
            guard let currentUser = API.RepHubUser.CURRENT_USER else {
                return
            }
            let newUserWorkoutRef = API.UserWorkouts.USER_WORKOUTS_DB_REF.child(currentUser.uid).child(newWorkoutRef.key)
            newUserWorkoutRef.setValue(true, withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                print("saved user-workout!")

            })
        } else {
            ProgressHUD.showError("Name missing!")
        }
    }
    
    @objc private func cancelCreateWorkout(){
        dismiss(animated: true, completion: nil)
    }
    
    
    private func loadExercises() {
        for id in self.exercisesForWorkout {
            API.Exercise.observeExercise(withId: id, completion: {
                exercise in
                self.exercises.append(exercise)
                print("exercises: \(self.exercises)")
                self.tableview.reloadData()
            })
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExercise" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let exercisesTVC = destinationNavigationController.topViewController as! ExerciseTypesForWorkoutTableViewController
            exercisesTVC.delegate = self
        }
    }
}

extension CreateWorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercises.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutDetails", for: indexPath) as! CreateWorkoutDetailsTableViewCell
            cell.workoutDescriptionTextView.placeholder = "Description"
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddExercise", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise", for: indexPath)
            cell.textLabel?.text = self.exercises[indexPath.row - 2].name
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        else if indexPath.row == 1 {
            return 44
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.exercises.remove(at: indexPath.row - 2)
            self.tableview.deleteRows(at: [indexPath], with: .fade)
        }
    }
}



extension CreateWorkoutViewController : CreateWorkout_ExerciseTypesForWorkoutDelegate {
    func addExercisesForWorkout(exercisesToBeAdded: [String]) -> [String] {
        self.exercisesForWorkout.removeAll()
        self.exercisesForWorkout.append(contentsOf: exercisesToBeAdded)
        print("---createWorkout: \(self.exercisesForWorkout)")
        self.loadExercises()
        return self.exercisesForWorkout
    }
}
