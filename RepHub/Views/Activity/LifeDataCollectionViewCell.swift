//
//  LifeDataCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class LifeDataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    

    var activityData : ActivityData?{
        didSet {
            self.updateView()
        }
    }
    override func awakeFromNib() {
        self.titleLabel.text = ""
        self.valueLabel.text = "..."
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
    }

    
    
    private func updateView(){
        self.layer.borderColor = self.activityData?.color.withAlphaComponent(0.5).cgColor
        self.titleLabel.textColor = self.activityData?.color
        self.valueLabel.textColor = self.activityData?.color
        self.titleLabel.text = self.activityData?.label
        self.valueLabel.text = "\(self.activityData!.dailyTotal)/\(self.activityData!.target) ..."
    }
}
