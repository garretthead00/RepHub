//
//  CreateWorkoutExerciseTypesCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 5/17/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol WorkoutExerciseTypesDelegate {
    func addExercises(exercises: [Exercise])
}


private let reuseIdentifier = "ExerciseTypeCell"
private let exerciseTypes = ["Flexibility","Plyometric","Strength","Sport","Cardio","Breathing"]
private let exerciseSegueIdentifiers = ["ComplexExercise","ComplexExercise","ComplexExercise","ComplexExercise","ComplexExercise","ComplexExercise"]

class CreateWorkout_ExerciseTypesCollectionViewController: UICollectionViewController {

    var selectedExercises : [Exercise] = []
    var delegate : WorkoutExerciseTypesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(self.selectedExercises.count) selected"
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Exercises" {
            let exercisesTVC = segue.destination as! CreateWorkout_ExercisesTableViewController
            let exerciseType = sender as! String
            exercisesTVC.exerciseType = exerciseType
            exercisesTVC.delegate = self
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exerciseTypes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CreateWorkout_ExerciseTypeCollectionViewCell
        cell.exerciseType = exerciseTypes[indexPath.row]
        cell.delegate = self
        return cell
    }

    // MARK: UICollectionViewDelegate
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    @IBAction func doneButton_TouchUpInside(_ sender: Any) {
        print("done button pressed \(self.selectedExercises.count)")
        
        self.delegate?.addExercises(exercises: self.selectedExercises)
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension CreateWorkout_ExerciseTypesCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  32
        let collectionViewSize = self.collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension CreateWorkout_ExerciseTypesCollectionViewController : CreateWorkout_ExerciseTypeDelegate {
    func goToExercisesForType(exerciseType: String) {
        let index = exerciseTypes.firstIndex(of: exerciseType)
        performSegue(withIdentifier: "Exercises", sender: exerciseTypes[index!])
    }
}

extension CreateWorkout_ExerciseTypesCollectionViewController : SelectExerciseDelegate {
    func selectedExercises(exercises: [Exercise]) {
        self.selectedExercises.append(contentsOf: exercises)
        self.navigationItem.title = "\(self.selectedExercises.count) selected"
    }
}
