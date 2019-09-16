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
    
    var lifeData : LifeData? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        print("lifeDataAwake")
        self.titleLabel.text = ""
        self.valueLabel.text = "..."
        //self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    
    private func updateView(){
          print("printing life data")
        self.layer.backgroundColor = self.lifeData?.color?.withAlphaComponent(0.5).cgColor
        self.titleLabel.text = self.lifeData?.label
        self.valueLabel.text = "\(self.lifeData?.value)/\(self.lifeData?.target) ..."
    }
}
