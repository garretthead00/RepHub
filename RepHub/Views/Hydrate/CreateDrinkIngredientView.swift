//
//  CreateDrinkIngredientView.swift
//  RepHub
//
//  Created by Garrett Head on 1/5/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class CreateDrinkIngredientView: UITableViewCell {
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    var delegate : CreateFoodDelegate?
    var ingredient : FoodItem?
    var servingSize : String?
    var unit : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.servingSize = ""
        self.unit = ""
        
        self.ingredientLabel.text = ""
        self.valueLabel.text = ""
    }
    
    private func updateView(){
        if let ingredient = self.ingredient, let serving = self.servingSize, let unit = self.unit {
            self.ingredientLabel.text = ingredient.name
            self.valueLabel.text = "\(serving) \(unit)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
