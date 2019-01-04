//
//  ExerciseTypesForWorkoutTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/17/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol CreateWorkout_ExerciseTypesForWorkoutDelegate {
    func addExercisesForWorkout(exercisesToBeAdded: [String]) -> [String]
}

class ExerciseTypesForWorkoutTableViewController: UITableViewController {

    let exerciseTypes = ["Strength","Isometric","Flexibility","Cardio","Agility","Breathing"]
    let segueIdentifiers = ["MuscleGroupsForWorkout", "MuscleGroupsForWorkout", "ExercisesForWorkout","ExercisesForWorkout","ExercisesForWorkout","ExercisesForWorkout"]
    var exercisesForWorkout = [String]()
    var delegate : CreateWorkout_ExerciseTypesForWorkoutDelegate!
    var exerciseId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(title:"Done",
                                       style: .plain ,
                                       target: self, action: #selector(doneButton_TouchUpInside))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func doneButton_TouchUpInside(){
        dismiss(animated: true, completion: nil)
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
        } else if segue.identifier == "MuscleGroupsForWorkout" {
            let muscleGroupsTVC = segue.destination as! MuscleGroupsForWorkoutTableViewController
            let exerciseType = sender as! String
            muscleGroupsTVC.exerciseType = exerciseType
            muscleGroupsTVC.delegate = self
        }
        
    }
    

}

extension ExerciseTypesForWorkoutTableViewController : ExerciseTypes_MuscleGroupsForWorkoutDelegate {
    func addExercisesForWorkout(exercisesToBeAdded: [String]) -> [String] {
        self.exercisesForWorkout = delegate.addExercisesForWorkout(exercisesToBeAdded: exercisesToBeAdded)
        return self.exercisesForWorkout
        
    }
    
}
