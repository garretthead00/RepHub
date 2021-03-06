//
//  ExerciseTypesForWorkoutTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/17/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol CreateWorkout_ExerciseTypesForWorkoutDelegate {
    func addExercises(exercises: [String])
}

class ExerciseTypesForWorkoutTableViewController: UITableViewController {

    let exerciseTypes = ["Strength","Isometric","Flexibility","Cardio","Agility","Breathing"]
    let segueIdentifiers = ["MuscleGroupsForWorkout", "MuscleGroupsForWorkout", "ExercisesForWorkout","ExercisesForWorkout","ExercisesForWorkout","ExercisesForWorkout"]
    var delegate : CreateWorkout_ExerciseTypesForWorkoutDelegate!
    var workoutId : String?
    var exercisesInWorkout = [String]()
    var nextIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(title:"Done",
                                       style: .plain ,
                                       target: self, action: #selector(doneButton_TouchUpInside))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func doneButton_TouchUpInside(){
//        for (index, exercise) in self.exercisesInWorkout.enumerated() {
//            API.WorkoutExercises.addWorkoutExercise(workoutId: self.workoutId!, workoutExerciseId: exercise, atIndex: self.nextIndex! + index)
//        }
        //self.addExercisesForWorkoutFromExercisesTVC(exercisesToBeAdded: self.exercisesInWorkout)
        
        self.delegate.addExercises(exercises: self.exercisesInWorkout)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseType", for: indexPath)
        cell.textLabel?.text = self.exerciseTypes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected indexPath.row \(indexPath.row)")
        print("withSegue: \(self.segueIdentifiers[indexPath.row])")
        performSegue(withIdentifier: self.segueIdentifiers[indexPath.row], sender: self.exerciseTypes[indexPath.row])
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExercisesForWorkout" {
            let exercisesTVC = segue.destination as! ExercisesForWorkoutTableViewController
            let exerciseType = sender as! String
            exercisesTVC.exerciseType = exerciseType
            exercisesTVC.exercisesInWorkout = self.exercisesInWorkout
            //exercisesTVC.delegate = self as! ExercisesForWorkoutDelegate
        } else if segue.identifier == "MuscleGroupsForWorkout" {
            let muscleGroupsTVC = segue.destination as! MuscleGroupsForWorkoutTableViewController
            let exerciseType = sender as! String
            muscleGroupsTVC.exerciseType = exerciseType
            muscleGroupsTVC.delegate = self
            muscleGroupsTVC.exercisesInWorkout = self.exercisesInWorkout
        }
        
    }
    

}

//extension ExerciseTypesForWorkoutTableViewController : ExerciseTypes_MuscleGroupsForWorkoutDelegate {
//    func addExercisesForWorkoutFromMuscleGroupsTVC(exercisesToBeAdded: [String]) {
//        self.exercisesInWorkout = exercisesToBeAdded
//        print("exercisesInWorkout from MuscleGroupsTVC: \(self.exercisesInWorkout)")
//        self.delegate.addExercisesForWorkout(exercisesToBeAdded: self.exercisesInWorkout)
//    }
//
//
//
//}

extension ExerciseTypesForWorkoutTableViewController : MuscleGroupsForWorkoutDelegate {
    func addExercises(exercises: [String]) {
        self.exercisesInWorkout = exercises
        print("exercisesInWorkout from ExercisesTVc: \(self.exercisesInWorkout)")
        //self.delegate.addExercisesForWorkout(exercisesToBeAdded: self.exercisesInWorkout)
        self.addExercises(exercises: self.exercisesInWorkout)
    }
}

extension ExerciseTypesForWorkoutTableViewController : ExercisesForWorkoutDelegate {
//    func addExercises(exercises: [String]) {
//        self.exercisesInWorkout = exercises
//        print("exercisesInWorkout from ExercisesTVc: \(self.exercisesInWorkout)")
//        self.delegate.addExercisesForWorkout(exercisesToBeAdded: self.exercisesInWorkout)
//    }
}
