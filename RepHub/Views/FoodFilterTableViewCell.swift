//
//  FoodFilterTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/10/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class FoodFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var filters : [String]? {
        didSet {
            self.filterCollectionView.delegate = self
            self.filterCollectionView.dataSource = self
            self.filterCollectionView.allowsSelection = true
            self.filterCollectionView.allowsMultipleSelection = false
            self.updateView()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func updateView() {
        self.filterCollectionView.reloadData()
    }

}

extension FoodFilterTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodFilter", for: indexPath) as! FoodFilterCollectionViewCell
        cell.filter = self.filters![indexPath.row]
        return cell
    }
    

}
extension FoodFilterTableViewCell  : UICollectionViewDelegateFlowLayout {
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
