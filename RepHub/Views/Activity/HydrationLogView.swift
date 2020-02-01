//
//  HydrationLogView.swift
//  RepHub
//
//  Created by Garrett Head on 1/30/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class HydrationLogView: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var drinkTypeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    
    var log : NutritionLog? {
        didSet{
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.drinkTypeLabel.text = ""
        self.servingLabel.text = ""
        self.imageView.image = UIImage.Theme.Activity.hydrate
        self.layer.cornerRadius = 12.0
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
    
    private func updateView(){
        
        if let food = log!.food {
            if let category = food.category {
                if let image = UIImage(named: category) {
                    if let serving = log!.householdServingSize, let unit = log!.householdServingSizeUnit {
                        self.imageView.image = image
                        self.drinkTypeLabel.text = category
                        self.servingLabel.text = "\(Int(serving)) \(unit)"
                    }
                    
                }
            }
        }
        
    }
    
}
