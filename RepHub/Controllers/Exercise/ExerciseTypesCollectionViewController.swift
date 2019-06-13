//
//  ExerciseTypesCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 4/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ExerciseTypeCell"
private let exerciseTypes = ["Flexibility","Plyometric","Strength","Sport","Cardio","Breathing"]
private let exerciseSegueIdentifiers = ["ComplexExercise","ComplexExercise","ComplexExercise","ComplexExercise","ComplexExercise","ComplexExercise"]

class ExerciseTypesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exercises" {
            let exercisesTVC = segue.destination as! ComplexExercisesTableViewController
            let exerciseType = sender as! String
            exercisesTVC.exerciseType = exerciseType
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExerciseTypesCollectionViewCell
        cell.exerciseType = exerciseTypes[indexPath.row]
        cell.delegate = self
        return cell
    }

    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }

}

extension ExerciseTypesCollectionViewController : UICollectionViewDelegateFlowLayout {
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

extension ExerciseTypesCollectionViewController : ExerciseTypeDelegate {
    func goToExercisesForType(exerciseType: String) {
        let index = exerciseTypes.firstIndex(of: exerciseType)
        performSegue(withIdentifier: "exercises", sender: exerciseTypes[index!])
    }
    
    
}
