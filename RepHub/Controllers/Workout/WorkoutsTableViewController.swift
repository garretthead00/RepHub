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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("workouts willAppear")
        
    }
    
    private func loadWorkouts(){
        self.workouts.removeAll()
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        API.Workout.observeUserWorkouts(withId: currentUserId, completion: {
            workout in
            self.workouts.append(workout)
            self.tableView.reloadData()
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
        API.Workout.WORKOUT_DB_REF.child(currentUserId).child(self.workouts[indexPath.row].id!).removeValue(completionBlock: {
            error, ref in
            API.WorkoutExercises.WORKOUT_EXERCISES_DB_REF.child(self.workouts[indexPath.row].id!).removeValue(completionBlock: {
                error, ref in
                    self.workouts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
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
            performSegue(withIdentifier: "Workout", sender: indexPath.row)
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
            //let workout = sender as! String
            let index = sender as! Int
            workoutTVC.workoutId = self.workouts[index].id
            workoutTVC.workout = self.workouts[index]//workout
            workoutTVC.delegate = self
        }
        
    }
 

}

extension WorkoutsTableViewController : WorkoutDelegate {
    func refreshWorkouts() {
        self.loadWorkouts()
    }
    
    
}
