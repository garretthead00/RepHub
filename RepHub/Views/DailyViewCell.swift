//
//  DailyViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 2/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class DailyViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var items : [String] = []
    var colors : [UIColor] = []
    var values : [String] = []
    var textColors : [UIColor] = []
    var icons : [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension DailyViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyItemCell", for: indexPath) as! DailyItemCollectionViewCell
        //cell.imageView.image = UIImage(named: "Chart")
        cell.label.text = "234 cal"
        print("DailyItemCell")
        cell.backgroundColor = self.colors[indexPath.row]
        cell.label.text = self.values[indexPath.row]
        cell.label.textColor = self.textColors[indexPath.row]
        
        // add a border
        cell.layer.borderColor = self.textColors[indexPath.row].cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        return cell
    }
    
    
}
extension DailyViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 2, height: 132)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

