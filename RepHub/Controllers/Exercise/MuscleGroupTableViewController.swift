//
//  MuscleGroupTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class MuscleGroupTableViewController: UITableViewController {

    let muscleGroups = ["Abdominals", "Chest", "Biceps", "Legs", "Lower Back", "Shoulders", "Triceps", "Back", "Calves"]
    var exerciseType : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.exerciseType
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.muscleGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MuscleGroup", for: indexPath)
        cell.textLabel?.text = self.muscleGroups[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Exercises", sender: [self.exerciseType,self.muscleGroups[indexPath.row]])
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Exercises" {
            let exercisesTVC = segue.destination as! ExercisesTableViewController
            let senderArr = sender as! [String]
            let exerciseType = senderArr[0] 
            let muscleGroup = senderArr[1] 
            exercisesTVC.exerciseType = exerciseType
            exercisesTVC.muscleGroup = muscleGroup
        }
    }
 

}
