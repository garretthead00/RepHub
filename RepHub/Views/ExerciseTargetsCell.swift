//
//  ExerciseSetsTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 2/4/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class ExerciseTargetsCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var numItemsInRow : Int?
    
    var exercise : WorkoutExercise? {
        didSet {
            print("set!!")
            self.collectionView.reloadData()
        }
    }
    var aSet : ExerciseSet?
    
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
        return numItemsInRow!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("dequeuing target cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseTargetSetCell", for: indexPath) as! ExeriseTargetSetCollectionViewCell
        cell.thisSet = ExerciseSet.init(set: indexPath.row + 1, weight: 125, reps: 8)
        cell.delegate = self
        return cell
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
    func promptExerciseSetMenu() {
        
    }
    

}
