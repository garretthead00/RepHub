//
//  ExerciseTypesTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class ExerciseTypesTableViewController: UITableViewController {

    let exerciseTypes = ["Strength","Isometric","Flexibility","Cardio","Agility","Breathing"]
    let segueIdentifiers = ["MuscleGroups", "MuscleGroups", "Exercises","Exercises","Exercises","Exercises"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        if segue.identifier == "Exercises" {
            let exercisesTVC = segue.destination as! ExercisesTableViewController
            let exerciseType = sender as! String
            exercisesTVC.exerciseType = exerciseType
        } else if segue.identifier == "MuscleGroups" {
            let muscleGroupsTVC = segue.destination as! MuscleGroupTableViewController
            let exerciseType = sender as! String
            muscleGroupsTVC.exerciseType = exerciseType
        }
    
    }
 

}
