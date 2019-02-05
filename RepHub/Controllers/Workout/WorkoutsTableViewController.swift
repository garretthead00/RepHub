//
//  WorkoutsTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class WorkoutsTableViewController: UITableViewController {

    var workouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addWorkout))
        self.loadWorkouts()
    }

    private func loadWorkouts(){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        API.UserWorkouts.USER_WORKOUTS_DB_REF.child(currentUserId).observe(.childAdded, with: {
            snapshot in
            API.Workout.observeWorkout(withId: snapshot.key, completion: {
                workout in
                self.workouts.append(workout)
                self.tableView.reloadData()
            })
        })
    }

    @objc private func addWorkout(){
        print("addWorkout")
        performSegue(withIdentifier: "CreateWorkout", sender: self)
    }
    
    private func removeWorkout(indexPath: IndexPath){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        API.UserWorkouts.USER_WORKOUTS_DB_REF.child(currentUserId).child(self.workouts[indexPath.row].id!).removeValue(completionBlock: {
            error, ref in
            API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(self.workouts[indexPath.row].id!).removeValue(completionBlock: {
                error, ref in
                API.Workout.WORKOUT_DB_REF.child(self.workouts[indexPath.row].id!).removeValue(completionBlock: {
                    error, ref in
                    self.workouts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                })
                
            })
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workouts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Workout", for: indexPath) as! WorkoutTableViewCell
        cell.workout = self.workouts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = self.workouts[indexPath.row].id {
            performSegue(withIdentifier: "Workout", sender: id)
        }
    }
 
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeWorkout(indexPath: indexPath)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Workout" {
            let workoutTVC = segue.destination as! WorkoutTableViewController
            let workout = sender as! String
            workoutTVC.workoutId = workout
        }
    }
 

}
