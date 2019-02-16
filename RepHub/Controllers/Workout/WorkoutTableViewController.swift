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
            self.navigationItem.title = self.workout!.name
           self.refreshController()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.showEditing(sender:)))
    }

    @objc func showEditing(sender: UIBarButtonItem){
        if self.tableView.isEditing {
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.tableView.reloadData()
        }
        else
        {
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Save"
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
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.exercises.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTargetsCell", for: indexPath) as! ExerciseTargetsCell
        cell.exercise = self.exercises[indexPath.row]
        cell.exerciseName = self.exerciseNames[indexPath.row]
        cell.delegate = self
        return cell

     }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if self.exercises[indexPath.row].targets != nil, let count = self.exercises[indexPath.row].targets?.count, count > 0 {
            return calculateRowHeight(count: count)
        } else {
            return calculateRowHeight(count: 1)
        }
        
        
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
        return true
    }
 
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveExercise = self.exercises[sourceIndexPath.row]
        exercises.remove(at: sourceIndexPath.row)
        exercises.insert(moveExercise, at: destinationIndexPath.row)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.exercises.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }


}

extension WorkoutTableViewController : ExerciseTargetsCellDelegate {
    func promptExerciseSetMenu(cell: ExerciseTargetsCell, set: Int) {
        if let index = self.tableView.indexPath(for: cell) {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
            if self.exercises[index.row].targets!.count > 0 {
                let editAction = UIAlertAction(title: "Edit Set", style: .default, handler: { action in
                    if let targetId = self.exercises[index.row].targets![set].id {
                        self.editTarget(withWorkoutExerciseId: self.exercises[index.row].id!, targetId: targetId)
                    }
                    
                })
                alert.addAction(editAction)
            }

            let addAction = UIAlertAction(title: "Add Set", style: .default, handler: { action in
                let newSet = self.exercises[index.row].targets!.count > 0 ? self.exercises[index.row].targets!.count : 1
                self.addTarget(workoutExerciseId: self.exercises[index.row].id! ,set: newSet)
            })
            let removeAction = UIAlertAction(title: "Remove Set", style: .default, handler: { action in
                // removes the current set
                self.removeTarget()
            })
    
    
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                // cancel alertcontroller
            })
    
            removeAction.setValue(UIColor.red, forKey: "titleTextColor")
            cancelAction.setValue(UIColor.darkGray, forKey: "titleTextColor")

            alert.addAction(addAction)
            alert.addAction(removeAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }

    
    private func editTarget(withWorkoutExerciseId id: String, targetId: String) {
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
                API.ExerciseTarget.editTarget(withWorkoutExerciseId: id, targetId: targetId, reps: repsVal!, weight: weightVal!, onSuccess: {
                    success in
                    if success {
                        self.refreshController()
                    }
                })
                
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
    
    private func removeTarget() {
        
    }
    
    
}
