//
//  ExercisesForWorkoutTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/17/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol MuscleGroup_ExercisesForWorkoutDelegate {
    func addExercisesForWorkout(exercisesToBeAdded: [String]) -> [String]
}


enum exercisesForWorkoutSearchBarItems: String {
    case freeWeight = "Free Weight"
    case machine = "Machine"
    case cable = "Cable"
}


class ExercisesForWorkoutTableViewController: UITableViewController {

    var exercisesForWorkout = [String]()
    private var exercises = [Exercise]()
    private var exercisesForSelectedModality = [Exercise]()
    private var filteredExercises = [Exercise]()
    var exerciseType : String!
    var muscleGroup : String!
    private var isSearching: Bool = false
    private var searchBar = UISearchBar()
    var delegate : MuscleGroup_ExercisesForWorkoutDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarSetup()
        self.loadExercises()
        self.navigationItem.title = self.muscleGroup != nil ? self.muscleGroup : self.exerciseType
        let doneButton = UIBarButtonItem(title:"Done",
                                         style: .plain ,
                                         target: self, action: #selector(doneButton_TouchUpInside))
        self.navigationItem.rightBarButtonItem = doneButton
        self.tableView?.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func loadExercises() {
        API.Exercise.observeExercises(completion: {
            exercise in
            self.exercises.append(exercise)
            self.exercises = self.exercises.filter { $0.exerciseType == self.exerciseType && $0.muscleGroup == self.muscleGroup}
            self.exercisesForSelectedModality = self.exercises.filter { $0.modality == searchBarItems.freeWeight.rawValue }
            self.tableView.reloadData()
        })
    }
    
    @objc private func doneButton_TouchUpInside(){
        print(self.exercisesForWorkout)
        self.exercisesForWorkout = delegate.addExercisesForWorkout(exercisesToBeAdded: self.exercisesForWorkout)
       self.navigationController?.popViewController(animated: true)
    }
    
    // Create the searchbar in code
    private func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width), height: 70))
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        searchBar.scopeButtonTitles = [exercisesForWorkoutSearchBarItems.freeWeight.rawValue, exercisesForWorkoutSearchBarItems.machine.rawValue, exercisesForWorkoutSearchBarItems.cable.rawValue]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.placeholder = "Search";
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching { return self.filteredExercises.count }
        else { return self.exercisesForSelectedModality.count }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var exercisesToDisplay = [Exercise]()
        let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise", for: indexPath) as! ExercisesForWorkoutTableViewCell
        exercisesToDisplay = self.isSearching ? self.filteredExercises : self.exercisesForSelectedModality
        cell.exercise = exercisesToDisplay[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! ExercisesForWorkoutTableViewCell
        if let id = cell.exercise?.id {
            print("---id: \(id)")
            self.exercisesForWorkout.append(id)//cell.exercise?.id
            print("---exercisesForWorkout: \(self.exercisesForWorkout)")
        }
  
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! ExercisesForWorkoutTableViewCell
        if let id = cell.exercise?.id {
            print("---id: \(id)")
            self.exercisesForWorkout = self.exercisesForWorkout.filter({ $0 != id})
            print("---exercisesForWorkout: \(self.exercisesForWorkout)")
        }
    }


}

extension ExercisesForWorkoutTableViewController : UISearchBarDelegate {
    
    // Filters the exercise list when the user selects a scope button.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.exercisesForSelectedModality.removeAll()
        switch (selectedScope){
        case exercisesForWorkoutSearchBarItems.freeWeight.hashValue:
            self.exercisesForSelectedModality = self.exercises.filter { $0.modality == exercisesForWorkoutSearchBarItems.freeWeight.rawValue}
            self.tableView.reloadData()
        case exercisesForWorkoutSearchBarItems.machine.hashValue:
            self.exercisesForSelectedModality = self.exercises.filter { $0.modality == exercisesForWorkoutSearchBarItems.machine.rawValue}
            self.tableView.reloadData()
        case exercisesForWorkoutSearchBarItems.cable.hashValue:
            self.exercisesForSelectedModality = self.exercises.filter { $0.modality == exercisesForWorkoutSearchBarItems.cable.rawValue}
            self.tableView.reloadData()
        default:
            print("no modality filter selected")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredExercises.removeAll()
        if searchText.isEmpty {
            isSearching = false
            self.tableView.reloadData()
        } else {
            isSearching = true
            self.filteredExercises = self.exercisesForSelectedModality.filter({( ex : Exercise) -> Bool in
                return (ex.name?.lowercased().contains(searchText.lowercased()))!
            })
            tableView.reloadData()
        }
    }
}
