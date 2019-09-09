//
//  FoodFilterCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class FoodFilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filterLabel: UILabel!
    var filter : String? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.filterLabel.text = ""
    }
    
    private func updateView() {
        self.filterLabel.text = self.filter
    }
    
    
    
    
}
