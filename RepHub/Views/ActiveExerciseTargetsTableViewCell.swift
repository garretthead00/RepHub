//
//  ActiveExerciseTargetsTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 3/1/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol ActiveWorkoutExerciseTargetsDelegate {
    func startBreak(withWorkoutExerciseId id: String) -> Int
    func addExerciseLog(withWorkoutExerciseId: String, exerciseId: String, set: Int)
    func addAdditionalExerciseLog(withWorkoutExerciseId: String, exerciseId: String, set: Int)
}

class ActiveExerciseTargetsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var exerciseName : String?
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
        if self.exercise?.targets != nil, let count = self.exercise?.targets!.count, count > 0 {
            return count
        }
        return 1
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActiveExerciseTargetCollectionViewCell", for: indexPath) as! ActiveExerciseTargetCollectionViewCell
        
        if self.exercise!.logs != nil, self.exercise?.targets != nil{
            if self.exercise!.logs!.count >= self.exercise!.targets!.count {
                // display only logs
            }
            else {
                let log = self.exercise!.logs?.filter({ $0.set == self.exercise!.targets![indexPath.row].set}).first
                if log != nil {
                    cell.exerciseSet = ExerciseSet.init(set: log!.set! , weight: log!.weight!, reps: log!.reps!, score: 0.0)
                    cell.setBorderColor = UIColor.darkGray.cgColor
                    cell.setBackgroundColor = UIColor.lightGray.cgColor
                } else {
                    cell.exerciseSet = ExerciseSet.init(set: indexPath.row , weight: self.exercise!.targets![indexPath.row].weight!, reps: self.exercise!.targets![indexPath.row].reps!, score: 0.0)
                    cell.setBorderColor = UIColor.darkGray.cgColor
                    cell.setBackgroundColor = UIColor.lightGray.cgColor
                }
            }
        } else {
            cell.setBorderColor = UIColor.darkGray.cgColor
            cell.setBackgroundColor = UIColor.lightGray.cgColor
            cell.exerciseSet = ExerciseSet.init(set: 0, weight: 0, reps: 0, score: 0.0)
        }
        
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ActiveWorkoutExerciseCollectionReusableView", for: indexPath) as! ActiveWorkoutExerciseCollectionReusableView
        headerView.delegate = self
        if self.exercise != nil {
            headerView.exerciseName = self.exerciseName
            headerView.countdown = self.exercise?.breakTime
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
    func startBreak() -> Int {
        let breakTime = self.delegate?.startBreak(withWorkoutExerciseId: self.exercise!.id!)
        self.exercise!.breakTime = breakTime
        return breakTime!
    }
    
    
//    func startBreak() {
////        if let time = exercise!.breakTime {
////            print("time: \(time)")
////         self.delegate?.startBreak(withTime: time)
////        } else {
////            print("no time")
////            self.delegate?.startBreak(withTime: 0)
////        }
//        
//
//    }
    
    
    
    
}
