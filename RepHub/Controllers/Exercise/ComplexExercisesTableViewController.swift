//
//  ComplexExercisesTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 4/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class ComplexExercisesTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    private var exercises = [Exercise]()
    private var filteredExercises = [Exercise]()

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
        self.navigationItem.title = self.exerciseType
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
        if self.muscleGroups!.count == 0 && self.modalities!.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
            let exerciseIndex = indexPath.row
            cell.textLabel?.text = self.filteredExercises[exerciseIndex].name
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

}

extension ComplexExercisesTableViewController : UISearchBarDelegate {
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

extension ComplexExercisesTableViewController : UpdateModalityFilterDelegate {
    func updateModalityFilter(modality: String) {
        self.modalityFilter = modality
        refreshFilter()
    }
}

extension ComplexExercisesTableViewController : UpdateMuscleGroupFilterDelegate {
    func updateMuscleGroupFilter(muscleGroup: String) {
        self.muscleGroupFilter = muscleGroup
        refreshFilter()
    }

}

