//
//  ExerciseModalityFilterTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 4/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

protocol UpdateModalityFilterDelegate {
    func updateModalityFilter(modality: String)
}

class ExerciseModalityFilterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate : UpdateModalityFilterDelegate?
    var modalities : [String]? {
        didSet {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.allowsSelection = true
            self.collectionView.allowsMultipleSelection = false
            self.collectionView.reloadData()
        }
    }
    var selectedModality : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}

extension ExerciseModalityFilterTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modalities!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "modalityCell", for: indexPath) as! ExerciseModalityFilterCollectionViewCell
        cell.modality = self.modalities![indexPath.row]
        cell.delegate = self
        cell.isSelected = (selectedModality == self.modalities![indexPath.row]) ? true : false
        return cell
    }

}

extension ExerciseModalityFilterTableViewCell : UICollectionViewDelegateFlowLayout {
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

extension ExerciseModalityFilterTableViewCell : SetModalityFilterProtocol {
    func setModality(modality: String) {
        delegate?.updateModalityFilter(modality: modality)
    }
    
    
}
