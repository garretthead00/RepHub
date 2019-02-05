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
    var exercisesForWorkout = [String]()
    var workoutId : String?
    var workout = Workout()
    
    var randNums = [3,5,2,7,2,5,3,7,8,5,6,3]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.showEditing(sender:)))
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 420
        self.loadWorkout()
    }

    @objc func showEditing(sender: UIBarButtonItem){
        
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
                    self.tableView.reloadData()
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
                self.tableView.reloadData()
            })
        })
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.exercises.count * 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let calcRow = (row % 2 == 0) ? (row / 2) : ((row / 2) + 1)
        if row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
            cell.textLabel?.text = self.exerciseNames[indexPath.row - calcRow]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTargetsCell", for: indexPath) as! ExerciseTargetsCell
            cell.exercise = self.exercises[indexPath.row - calcRow]
            cell.numItemsInRow = randNums[indexPath.row - calcRow]
            return cell
        }

     }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row % 2 > 0) ? calculateRowHeight(row: indexPath.row) : 44
    }
    
    private func calculateRowHeight(row : Int) -> CGFloat {
        let calcRow = (row % 2 == 0) ? (row / 2) : ((row / 2) + 1)
        let totalItem: CGFloat = CGFloat(randNums[row - calcRow])
        let totalCellInARow: CGFloat = 2
        let cellHeight: CGFloat = 44
        
        let collViewTopOffset: CGFloat = 10
        let collViewBottomOffset: CGFloat = 10
        
        let minLineSpacing: CGFloat = 5
        
        // calculations
        let totalRow = ceil(totalItem / totalCellInARow)
        let totalTopBottomOffset = collViewTopOffset + collViewBottomOffset
        let totalSpacing = CGFloat(totalRow - 1) * minLineSpacing   // total line space in UICollectionView is (totalRow - 1)
        return (cellHeight * totalRow) + totalTopBottomOffset + totalSpacing
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
