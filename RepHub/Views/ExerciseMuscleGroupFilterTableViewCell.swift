//
//  ExerciseMuscleGroupTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 5/15/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol UpdateMuscleGroupFilterDelegate {
    func updateMuscleGroupFilter(muscleGroup: String)
}

class ExerciseMuscleGroupFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate : UpdateMuscleGroupFilterDelegate?
    var muscleGroups : [String]? {
        didSet {
//            self.collectionView.delegate = self
//            self.collectionView.dataSource = self
            self.collectionView.allowsSelection = true
            self.collectionView.allowsMultipleSelection = false
            self.collectionView.reloadData()
        }
    }
    var selectedMuscleGroup : String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension ExerciseMuscleGroupFilterTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.muscleGroups!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "muscleGroupCell", for: indexPath) as! ExerciseMuscleGroupFilterCollectionViewCell
        cell.muscleGroup = self.muscleGroups![indexPath.row]
        cell.delegate = self
        cell.isSelected = (selectedMuscleGroup == self.muscleGroups![indexPath.row]) ? true : false
        return cell
    }
    
    
}

extension ExerciseMuscleGroupFilterTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 148.0, height: 48.0)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 2)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
}

extension ExerciseMuscleGroupFilterTableViewCell : SetMuscleGroupFilterProtocol {
    func setMuscleGroup(muscleGroup: String) {
        delegate?.updateMuscleGroupFilter(muscleGroup: muscleGroup)
    }
    
    
}

