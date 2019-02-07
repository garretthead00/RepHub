//
//  WeeklyViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 2/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class WeeklyViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var items : [String] = []
    var colors : [UIColor] = []
    var values : [String] = []
    var textColors : [UIColor] = []
    var icons : [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        print("weeklyViewCell awakwFromNib")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension WeeklyViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyItemCell", for: indexPath) as! WeeklyItemCollectionViewCell
        //cell.imageView.image = UIImage(named: "Chart")
        print("WeeklyItemCell")
        cell.backgroundColor = self.colors[indexPath.row]
        // add a border
        cell.layer.borderColor = self.textColors[indexPath.row].cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        return cell
    }
    
    
}

extension WeeklyViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 228)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
