//
//  CreateDrinkDetailsView.swift
//  RepHub
//
//  Created by Garrett Head on 1/5/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

protocol CreateFoodDelegate {
    func updateName(name: String)
    func updateFoodGroup(foodGroup: String)
    func updateIngredients(ingredients: [FoodItem])
    func updateNutrients(nutrients: [Nutrient])
    func updateUploadImage(image: UIImage)
    func updateDescription(description: String)
    func updateServingSize(serving: Double)
    func updateServingUnit(unit: String)
}

class CreateDrinkNameView: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    private var categories = ["- category -","A", "B", "C", "other"]
    
    var name : String?
    var foodGroup : String? = "Drinks"
    
    
    var delegate : CreateFoodDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameTextField.text = ""
        self.nameTextField.addTarget(self, action: #selector(nameIsUpdating), for: .editingChanged)
    }
    
    @objc private func nameIsUpdating(){
        if let name = self.nameTextField.text {
            self.name = name
            delegate?.updateName(name: name)
        }
    }

    
    private func updateView(){
        if let name = self.name {
            self.nameTextField.text = name
        }
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}

