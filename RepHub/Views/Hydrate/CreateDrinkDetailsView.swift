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
    func updateCategory(category: String)
    func updateOtherCategory(category: String)
    func updateIngredients(ingredients: [FoodItem])
    func updateNutrients(nutrients: [Nutrient])
    func updateUploadImage(image: UIImage)
    func updateDescription(description: String)
    func updateServingSize(serving: Double)
    func updateServingUnit(unit: String)
}

class CreateDrinkDetailsView: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var otherCategoryTextField: UITextField!
    
    private var categories = ["- category -","A", "B", "C", "other"]
    
    var name : String?
    var foodGroup : String? = "Drinks"
    var category : String?
    var otherCategory : String?
    
    var delegate : CreateFoodDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.nameTextField.text = ""
        self.otherCategoryTextField.text = ""
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        self.categoryPicker.selectRow(0, inComponent: 0, animated: false)
        self.nameTextField.addTarget(self, action: #selector(nameIsUpdating), for: .editingChanged)
        self.otherCategoryTextField.addTarget(self, action: #selector(categoryIsUpdating), for: .editingChanged)
    }
    
    @objc private func nameIsUpdating(){
        if let name = self.nameTextField.text {
            self.name = name
            delegate?.updateName(name: name)
        }
    }
    @objc private func categoryIsUpdating(){
        if let otherCategory = self.otherCategoryTextField.text {
            self.otherCategory = otherCategory
            delegate?.updateOtherCategory(category: otherCategory)
        }
    }
    
    private func updateView(){
        if let name = self.name {
            self.nameTextField.text = name
        }
        if let category = self.category, let index = self.categories.firstIndex(of: category) {
            self.categoryPicker.selectRow(index, inComponent: 0, animated: false)
        }
        
        if let otherCategory = self.otherCategory {
            self.otherCategoryTextField.text = otherCategory
        }

    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}

extension CreateDrinkDetailsView : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected category: \(self.categories[row])")
        self.category = self.categories[row]
        if let category = self.category{
            delegate?.updateCategory(category: category)
            self.updateView()
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row]
    }
    
}
