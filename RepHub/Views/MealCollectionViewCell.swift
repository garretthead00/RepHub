//
//  MealCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    var meal : String? {
        didSet {
            self.updateView()
        }
    }
    var cals : String? {
        didSet {
            self.updateView()
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.image = nil
        self.mealLabel.text = ""
        self.calorieLabel.text = ""

        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    private func updateView() {
        self.imageView.image = UIImage(named: self.meal!)!
        self.mealLabel.text = self.meal
        self.calorieLabel.text = cals
    }
    
}
