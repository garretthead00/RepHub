//
//  DrinkFiltersTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 1/1/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit



class DrinkFiltersTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var filters : [String]? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    private func updateView(){
        self.collectionView.reloadData()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension DrinkFiltersTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterView", for: indexPath) as! DrinkFilterCollectionViewCell
        cell.filterText = self.filters![indexPath.row]

        return cell
    }
    
    
}

extension DrinkFiltersTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let itemWidth = UIScreen.main.bounds.width / 3
//        return CGSize(width: itemWidth, height: 36.0)
        return CGSize(width: 92.0, height: 36.0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 2)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//

}

