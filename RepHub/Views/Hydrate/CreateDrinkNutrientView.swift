//
//  CreateDrinkNutrientView.swift
//  RepHub
//
//  Created by Garrett Head on 1/5/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class CreateDrinkNutrientView: UITableViewCell {
    @IBOutlet weak var nutrientLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    var delegate : CreateFoodDelegate?
    var nutrient : Nutrient?
    var value : String?
    var unit : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.value = ""
        self.unit = ""
        
        self.nutrientLabel.text = ""
        self.valueLabel.text = ""
    }
    
    private func updateView(){
        if let nutrient = self.nutrient, let value = self.value, let unit = self.unit {
            self.nutrientLabel.text = nutrient.name
            self.valueLabel.text = "\(value) \(unit)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
