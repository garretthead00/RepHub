//
//  EnergyBalanceCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 10/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class EnergyBalanceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    var message : String? {
        didSet {
            self.updateView()
        }
    }
    
    private func updateView(){
        print("EnergyBalanceCollectionViewCell Hey!")
        self.label1.text = "oh"
        self.label2.text = "yeh"
    }
    
    override func awakeFromNib() {
        self.label1.text = ""
        self.label2.text = "..."
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
    }
    
}
