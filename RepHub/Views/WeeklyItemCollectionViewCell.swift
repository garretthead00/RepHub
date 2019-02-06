//
//  WeeklyItemCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 2/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class WeeklyItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("WeeklyItemCollectionViewCell")
    }
}
