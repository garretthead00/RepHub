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
    
    var activity : Activity? {
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
        self.layer.borderColor = self.activity!.color!.withAlphaComponent(0.5).cgColor
        self.titleLabel.textColor = self.activity!.color!
        self.valueLabel.textColor = self.activity!.color!
        self.titleLabel.text = self.activity!.label!
        self.valueLabel.text = "\(self.activity!.dailyTotal!)/\(self.activity!.target!) ..."
    }
}
