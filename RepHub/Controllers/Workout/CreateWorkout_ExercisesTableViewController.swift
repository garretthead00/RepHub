//
//  CreateWorkout_ExercisesTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 5/17/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol SelectExerciseDelegate {
    func selectedExercises(exercises: [Exercise])
}


class CreateWorkout_ExercisesTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate : SelectExerciseDelegate?
    
    private var exercises = [Exercise]()
    private var filteredExercises = [Exercise]()
    private var selectedExercises = [Exercise]()
    
    
    var modalities : [String]?
    var muscleGroups : [String]?
    var exerciseType : String? {
        didSet {
            self.loadExercises()
        }
    }
    
    // FILTER PARAMETERS
    private var isSearching : Bool = false
    private var modalityFilter : String = ""
    private var muscleGroupFilter : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(self.selectedExercises.count) selected"
        self.navigationItem.leftBarButtonItem?.title = "Back"
        self.tableView.allowsMultipleSelection = true
        self.searchBar.delegate = self
        refreshFilter()
    }
    
    
    private func loadExercises(){
        self.modalities = [String]()
        self.muscleGroups = [String]()
        API.Exercise.observeExercises(ofType: self.exerciseType!, completion: {
            exercise in
            self.exercises.append(exercise)
            self.filteredExercises = self.exercises
            if !self.modalities!.contains(exercise.modality!) {
                self.modalities?.append(exercise.modality!)
            }
            
            if exercise.muscleGroup != nil {
                for group in exercise.muscleGroup! {
                    if !self.muscleGroups!.contains(group) {
                        self.muscleGroups?.append(group)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    private func refreshFilter() {
        self.filteredExercises = self.exercises
        if modalityFilter != "" {
            self.filteredExercises = self.filteredExercises.filter {
                $0.modality == modalityFilter
            }
        }
        if muscleGroupFilter != "" {
            self.filteredExercises = self.filteredExercises.filter {
                ($0.muscleGroup != nil) && ($0.muscleGroup?.contains(muscleGroupFilter))!
            }
        }
        self.tableView.reloadData()
    }
    
    
    
    @IBAction func doneButton_TouchUpInside(_ sender: Any) {
        self.delegate?.selectedExercises(exercises: self.selectedExercises)
        self.navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.muscleGroups!.count == 0 && self.modalities!.count == 0 {
            return self.filteredExercises.count
        } else if (self.muscleGroups!.count == 0 && self.modalities!.count > 0) || (self.muscleGroups!.count > 0 && self.modalities!.count == 0) {
            return self.filteredExercises.count + 1
        } else {
            return self.filteredExercises.count + 2
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // if the current filteredExercise is in selectedExercises

        
       
        
        
        
        if self.muscleGroups!.count == 0 && self.modalities!.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
            let exerciseIndex = indexPath.row
            cell.textLabel?.text = self.filteredExercises[exerciseIndex].name
            let isSelected = self.selectedExercises.contains {
                $0.id == self.filteredExercises[exerciseIndex].id
            }
            if isSelected {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            
            return cell
        } else if (self.muscleGroups!.count == 0 && self.modalities!.count > 0) || (self.muscleGroups!.count > 0 && self.modalities!.count == 0) {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ModalityFilterCell", for: indexPath) as! ExerciseModalityFilterTableViewCell
                cell.modalities = self.modalities
                cell.selectedModality = self.modalityFilter
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
                let exerciseIndex = indexPath.row - 1
                cell.textLabel?.text = self.filteredExercises[exerciseIndex].name
                
                let isSelected = self.selectedExercises.contains {
                    $0.id == self.filteredExercises[exerciseIndex].id
                }
                if isSelected {
                    cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                } else {
                    cell.accessoryType = UITableViewCell.AccessoryType.none
                }
                return cell
            }
        } else {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MuscleGroupFilterCell", for: indexPath) as! ExerciseMuscleGroupFilterTableViewCell
                cell.muscleGroups = self.muscleGroups
                cell.selectedMuscleGroup = self.muscleGroupFilter
                cell.delegate = self
                return cell
                
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ModalityFilterCell", for: indexPath) as! ExerciseModalityFilterTableViewCell
                cell.modalities = self.modalities
                cell.selectedModality = self.modalityFilter
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
                let exerciseIndex = indexPath.row - 2
                cell.textLabel?.text = self.filteredExercises[exerciseIndex].name
                let isSelected = self.selectedExercises.contains {
                    $0.id == self.filteredExercises[exerciseIndex].id
                }
                if isSelected {
                    cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                } else {
                    cell.accessoryType = UITableViewCell.AccessoryType.none
                }
                return cell
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.muscleGroups!.count == 0 && self.modalities!.count == 0 {
            return 44
        } else if (self.muscleGroups!.count == 0 && self.modalities!.count > 0) || (self.muscleGroups!.count > 0 && self.modalities!.count == 0) {
            return indexPath.row == 0 ? 72 : 44
        } else {
            return indexPath.row <= 1 ? 72 : 44
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var exerciseIndexSelected : Int?
        if self.muscleGroups!.count == 0 && self.modalities!.count == 0 {
           exerciseIndexSelected = indexPath.row
        } else if (self.muscleGroups!.count == 0 && self.modalities!.count > 0) || (self.muscleGroups!.count > 0 && self.modalities!.count == 0) {
           exerciseIndexSelected = indexPath.row - 1
        } else {
            exerciseIndexSelected = indexPath.row - 2
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell!.isSelected {
            cell!.isSelected = false
            if cell!.accessoryType == UITableViewCell.AccessoryType.none {
                cell!.accessoryType = UITableViewCell.AccessoryType.checkmark
                self.selectedExercises.append(self.filteredExercises[exerciseIndexSelected!])
            }
            else {
                cell!.accessoryType = UITableViewCell.AccessoryType.none
                if let index = self.selectedExercises.firstIndex(where: {$0.id == self.filteredExercises[exerciseIndexSelected!].id}) {
                    self.selectedExercises.remove(at: index)
                }
            }
        }
        self.navigationItem.title = "\(self.selectedExercises.count) selected"
    }

}

extension CreateWorkout_ExercisesTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearching = false
            self.refreshFilter()
        } else {
            self.isSearching = true
            self.filteredExercises = self.filteredExercises.filter({( ex : Exercise) -> Bool in
                return (ex.name?.lowercased().contains(searchText.lowercased()))!
            })
            tableView.reloadData()
        }
    }
}

extension CreateWorkout_ExercisesTableViewController : UpdateModalityFilterDelegate {
    func updateModalityFilter(modality: String) {
        self.modalityFilter = modality
        refreshFilter()
    }
}

extension CreateWorkout_ExercisesTableViewController : UpdateMuscleGroupFilterDelegate {
    func updateMuscleGroupFilter(muscleGroup: String) {
        self.muscleGroupFilter = muscleGroup
        refreshFilter()
    }
    
}

