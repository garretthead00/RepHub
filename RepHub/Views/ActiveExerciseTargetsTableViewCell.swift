//
//  ActiveExerciseTargetsTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 3/1/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ActiveWorkoutExerciseTargetsDelegate {
    func startBreak(countdown: Int)
    func addExerciseLog(withWorkoutExerciseId: String, exerciseId: String, set: Int)
    func addAdditionalExerciseLog(withWorkoutExerciseId: String, exerciseId: String, set: Int)
}

class ActiveExerciseTargetsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var exercise : WorkoutExercise? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var targets : [ExerciseTarget]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var logs : [ExerciseLog]? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var delegate : ActiveWorkoutExerciseTargetsDelegate? {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    var countdown : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ActiveExerciseTargetsTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exercise!.sets!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActiveExerciseTargetCollectionViewCell", for: indexPath) as! ActiveExerciseTargetCollectionViewCell
        cell.delegate = self
        cell.exercise = self.exercise
        cell.index = indexPath.row
        cell.logs = self.exercise?.logs
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ActiveWorkoutExerciseCollectionReusableView", for: indexPath) as! ActiveWorkoutExerciseCollectionReusableView
        headerView.delegate = self
        if self.exercise != nil {
            headerView.exerciseName = self.exercise?.name
            headerView.countdown = self.countdown
            headerView.workoutExerciseId = self.exercise?.id
            
        }
        return headerView
    }
}

extension ActiveExerciseTargetsTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 2, height: 44.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension ActiveExerciseTargetsTableViewCell : ActiveExerciseTargetSetDelegate {
    func addExerciseLog(forSet: Int) {
        delegate?.addExerciseLog(withWorkoutExerciseId: self.exercise!.id!, exerciseId: self.exercise!.exerciseId!, set: forSet)
    }
}
extension ActiveExerciseTargetsTableViewCell : ActiveWorkoutExerciseDelegate {
    func startBreak(countdown: Int){
        self.delegate?.startBreak(countdown: countdown)
    }
}
