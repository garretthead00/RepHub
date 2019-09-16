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
    func setBreak(withId id: String)
    func addSet(withId id: String, set: Int)
}



class ExerciseTargetsCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate : ExerciseTargetsCellDelegate? {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    var borderColors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.orange.cgColor, UIColor.blue.cgColor]
    var backgroundColors = [UIColor(red: 0.97, green: 0.45, blue: 0.45, alpha: 1.0).cgColor, UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0).cgColor, UIColor(red:1.00, green:0.58, blue:0.00, alpha:1.0).cgColor, UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0).cgColor]
    
    var exercise : WorkoutExercise? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var aSet : ExerciseSet?
    var exerciseName : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) 

        // Configure the view for the selected state
    }

}

extension ExerciseTargetsCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.exercise?.targets != nil, let count = self.exercise?.targets!.count, count > 0 {
            return count + 1
        }
        return 1
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseTargetSetCell", for: indexPath) as! ExeriseTargetSetCollectionViewCell
        if self.exercise!.targets != nil, let count = self.exercise!.targets?.count, count > 0, indexPath.row < count {
            cell.thisSet = ExerciseSet.init(set: indexPath.row , weight: self.exercise!.targets![indexPath.row].weight!, reps: self.exercise!.targets![indexPath.row].reps!, score: 0.0)
        }
        else {
            cell.thisSet = ExerciseSet.init(set: 0 , weight: 0.0, reps: 0, score: 0.0)
            cell.setTextField.text = ""
            cell.repLabel.text = "#"
            cell.weightTextField.text = "+"
        }

        cell.delegate = self
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WorkoutExerciseCollectionReusableView", for: indexPath) as! WorkoutExerciseCollectionReusableView
        headerView.delegate = self
        if self.exercise != nil {
            headerView.exerciseName = self.exerciseName
            headerView.workoutExerciseId = self.exercise?.id
            headerView.breakTime = self.exercise?.breakTime
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

    func editSet(cell: ExeriseTargetSetCollectionViewCell) {
        if let index = self.collectionView.indexPath(for: cell) {
            delegate?.promptExerciseSetMenu(cell: self, set: index.row)
        }
    }
    
    func addSet() {
        
        if let id = self.exercise?.id {
            print("add set--- withId: \(id)")
            if let set = self.exercise?.targets?.count {
                print("add set--- set: \(set)")
                delegate?.addSet(withId: id, set: set)
            }
        }
    }
    
    func promptExerciseSetMenu(cell: ExeriseTargetSetCollectionViewCell) {
        if let index = self.collectionView.indexPath(for: cell) {
            delegate?.promptExerciseSetMenu(cell: self, set: index.row)
        }
    }
    
    
    

}


extension ExerciseTargetsCell : WorkoutExerciseDelegate {
    func setBreak(withId id: String) {
        self.delegate?.setBreak(withId: id)
    }
    
    
    
    
}
