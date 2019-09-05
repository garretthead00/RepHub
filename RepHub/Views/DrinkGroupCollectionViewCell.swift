//
//  DrinkGroupCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class DrinkGroupCollectionViewCell: UICollectionViewCell {
    
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
        self.groupImageView.image = UIImage(named: self.group!)!
        self.groupLabel.text = self.group!
    }
    
}
