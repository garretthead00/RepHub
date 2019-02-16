//
//  ExerciseSetsTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 2/4/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ExerciseTargetsCellDelegate {
    func promptExerciseSetMenu(cell: ExerciseTargetsCell, set: Int)
}

class ExerciseTargetsCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate : ExerciseTargetsCellDelegate?
    
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
    
    var aSet : ExerciseSet?
    var exerciseName : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ExerciseTargetsCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.exercise?.targets != nil, let count = self.exercise?.targets!.count, count > 0 {
            return count
        }
        return 1
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseTargetSetCell", for: indexPath) as! ExeriseTargetSetCollectionViewCell
        if self.exercise!.targets != nil, let count = self.exercise!.targets?.count, count > 0 {
            cell.thisSet = ExerciseSet.init(set: self.exercise!.targets![indexPath.row].set!, weight: self.exercise!.targets![indexPath.row].weight!, reps: self.exercise!.targets![indexPath.row].reps!)
        } else {

            cell.thisSet = ExerciseSet.init(set: 0, weight: 0, reps: 0)
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WorkoutExerciseCollectionReusableView", for: indexPath) as! WorkoutExerciseCollectionReusableView
        if self.exercise != nil {
            headerView.exerciseName = self.exerciseName
        }
        return headerView
    }
    
    
}

extension ExerciseTargetsCell : UICollectionViewDelegateFlowLayout {
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

extension ExerciseTargetsCell : ExerciseTargetSetDelegate {
    func promptExerciseSetMenu(cell: ExeriseTargetSetCollectionViewCell) {
        if let index = self.collectionView.indexPath(for: cell) {
            print("set whaaa?? \(index)")
            delegate?.promptExerciseSetMenu(cell: self, set: index.row)
        }
        
    }
    

}
