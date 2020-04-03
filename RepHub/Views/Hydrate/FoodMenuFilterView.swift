//
//  DrinkFiltersTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 1/1/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

protocol FoodMenuFilterDelegate {
    func applyFilter(index: Int)
}

class FoodMenuFilterView: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var delegate : FoodMenuFilterDelegate?
    var selectedFilter : Int?
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

    private func updateView(){
        self.collectionView.reloadData()
    }
}

extension FoodMenuFilterView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterView", for: indexPath) as! FoodMenuFilterItemView
        if let selectedFilter = self.selectedFilter {
            cell.isSelected = (indexPath.row == selectedFilter) ? true : false
        }
        cell.filterText = self.filters![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.applyFilter(index: indexPath.row)
    }
}

extension FoodMenuFilterView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 92.0, height: 36.0)
    }
}

