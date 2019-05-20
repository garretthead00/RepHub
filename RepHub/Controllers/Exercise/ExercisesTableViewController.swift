//
//  ExercisesTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/8/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

enum searchBarItems: String {
    case freeWeight = "Free Weight"
    case machine = "Machine"
    case cable = "Cable"
    
    static let allValues = [freeWeight, machine, cable]
}


class ExercisesTableViewController: UITableViewController {

    private var exercises = [Exercise]()
    private var exercisesForSelectedModality = [Exercise]()
    private var filteredExercises = [Exercise]()
    var exerciseType : String!
    var muscleGroup : String!
    private var isSearching: Bool = false
    private var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarSetup()
        self.loadExercises()
        self.navigationItem.title = self.muscleGroup != nil ? self.muscleGroup : self.exerciseType
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func loadExercises() {
//        API.Exercise.observeExercises(completion: {
//            exercise in
//            self.exercises.append(exercise)
//            self.exercises = self.exercises.filter { $0.exerciseType == self.exerciseType && $0.muscleGroup == self.muscleGroup}
//            self.exercisesForSelectedModality = self.exercises.filter { $0.modality == searchBarItems.freeWeight.rawValue }
//            self.tableView.reloadData()
//        })
    }

    // Create the searchbar in code
    private func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width), height: 70))
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        searchBar.scopeButtonTitles = [searchBarItems.freeWeight.rawValue, searchBarItems.machine.rawValue, searchBarItems.cable.rawValue]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise", for: indexPath) as! ExercisesTableViewCell
        exercisesToDisplay = self.isSearching ? self.filteredExercises : self.exercisesForSelectedModality
        cell.exercise = exercisesToDisplay[indexPath.row]
        cell.delegate = self
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Exercise" {
            let exerciseVC = segue.destination as! ExerciseViewController
            let exerciseId = sender as! String
            exerciseVC.exerciseId = exerciseId
        }
    }

}

extension ExercisesTableViewController : UISearchBarDelegate {
    
    // Filters the exercise list when the user selects a scope button.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.exercisesForSelectedModality.removeAll()
        switch (exercisesForWorkoutSearchBarItems.allValues[selectedScope]){
        case exercisesForWorkoutSearchBarItems.freeWeight:
            self.exercisesForSelectedModality = self.exercises.filter { $0.modality == exercisesForWorkoutSearchBarItems.freeWeight.rawValue}
            self.tableView.reloadData()
        case exercisesForWorkoutSearchBarItems.machine:
            self.exercisesForSelectedModality = self.exercises.filter { $0.modality == exercisesForWorkoutSearchBarItems.machine.rawValue}
            self.tableView.reloadData()
        case exercisesForWorkoutSearchBarItems.cable:
            self.exercisesForSelectedModality = self.exercises.filter { $0.modality == exercisesForWorkoutSearchBarItems.cable.rawValue}
            self.tableView.reloadData()
        default:
            print("no modality filter selected \(selectedScope)")
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

extension ExercisesTableViewController: ExerciseCellDelegate {
    func gotoExerciseVC(exerciseId: String?) {
        performSegue(withIdentifier: "Exercise", sender: exerciseId)
    }
}
