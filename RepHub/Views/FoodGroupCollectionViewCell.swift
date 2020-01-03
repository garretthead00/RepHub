//
//  FoodGroupCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/28/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class FoodGroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupLabel: UILabel!
    
    
    var group : String? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupImageView.image = nil
        self.groupLabel.text = ""
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    private func updateView() {
        if let group = self.group {
            self.groupImageView.image = UIImage(named: group)!
            self.groupLabel.text = group
        }
        
    }
    
}
