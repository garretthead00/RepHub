//
//  DrinkFilterCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 1/1/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class FoodMenuFilterItemView: UICollectionViewCell {
    
    @IBOutlet weak var filterLabel: UILabel!
    
    var filterText : String? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.filterLabel.text = ""
        self.layer.cornerRadius = 12.0
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    private func updateView(){
        self.filterLabel.text = self.filterText!
        if self.isSelected {
            self.layer.backgroundColor = UIColor.Theme.seaFoam.cgColor
            self.filterLabel.textColor = UIColor.darkText
        }
        else {
            self.layer.backgroundColor = UIColor.darkGray.cgColor
            self.filterLabel.textColor = UIColor.lightText
        }
    }
    
  
    
}
