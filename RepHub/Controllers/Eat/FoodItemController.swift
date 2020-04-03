//
//  FoodItemController.swift
//  RepHub
//
//  Created by Garrett Head on 4/2/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class FoodItemController: UITableViewController {

    var foodItem : FoodItem? {
        didSet {
            self.loadNutritionFacts()
        }
    }

    
    var nutrients : [Nutrient] = []
    var groupedNutrients : [String : [Nutrient]] = [:] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var nutrientGroupName = ["","Macronutrient","Vitamin","Mineral","Ultratrace Mineral","Other"]
    var alwaysDisplayNutrients = ["Calories", "Protein", "Fat", "Carbohydrates", "Sugar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Eat", style: .plain, target: self, action: #selector(addTapped))
    }
    
    // MARK: API
    private func loadNutritionFacts(){
        if let foodItem = self.foodItem, let id = foodItem.id {
            let idStr = String(id)
            API.Nutrition.observeNutrition(withId: idStr, completion: {
                nutrient in
                if let name = nutrient.name, self.alwaysDisplayNutrients.contains(name) {
                    self.nutrients.append(nutrient)
                    self.groupNutrients(nutrients: self.nutrients)
                    self.tableView.reloadData()
                    
                } else if let value = nutrient.value, value > 0 {
                    self.nutrients.append(nutrient)
                    self.groupNutrients(nutrients: self.nutrients)
                    self.tableView.reloadData()
                }
                
            })
      
        }
    }
    
    private func groupNutrients(nutrients: [Nutrient]){
        self.groupedNutrients = Dictionary(grouping: nutrients, by: {
            element in
            return element.category!
        })
        self.tableView.reloadData()
    }
    
    
    
    @objc private func addTapped(){
        self.addLog()
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedNutrients.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 {
            let nutrientGroup = self.nutrientGroupName[section]
            if let nutrients = self.groupedNutrients[nutrientGroup] {
                let count = nutrients.count
                return count
            } else {
                return 0
            }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let nutrientGroup = self.nutrientGroupName[section]
        if let nutrients = self.groupedNutrients[nutrientGroup], nutrients.count > 0 {
            return nutrientGroup
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkDetails", for: indexPath) as! DrinkDetailsTableViewCell
            if let foodItem = self.foodItem {
                if let name = foodItem.name {
                    cell.name = name
                }
                if let source = foodItem.source {
                    cell.nutritionFactsMessage = "**Nutrition Facts provided by \(source)"
                }
                
                if let hhServingSize = foodItem.householdServingSize, let hhUnit = foodItem.householdServingSizeUnit, let servingSize = foodItem.servingSize, let unit = foodItem.servingSizeUnit {
                     cell.servingSize = "Amount per \(hhServingSize) \(hhUnit) (\(servingSize) \(unit))"
                }
            }
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Nutrient", for: indexPath)
            let nutrientGroup = self.nutrientGroupName[section]
            if let nutrient = self.groupedNutrients[nutrientGroup]?[row] {
                if let name = nutrient.name, let value = nutrient.value, let unit = nutrient.unit {
                    cell.textLabel?.text = name
                    cell.detailTextLabel?.text = "\(value) \(unit)"
                }
            } else {
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
            }
            return cell
            
        }

    }


}


extension FoodItemController {
    private func addLog(){
        let alertController = UIAlertController(title: foodItem!.name!, message: "\n", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "grams"
        })
        
        let confirmAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: ({
            (_) in
            if let field = alertController.textFields?[0] {
                if field.text != "", let quantity = Double(field.text!) {
                    if let foodItem = self.foodItem {
                        guard let currentUserId = API.RepHubUser.CURRENT_USER?.uid else {
                            return
                        }
                        
                        // Calculate nutrition metrics based on the input value.
                        let servings = quantity / foodItem.householdServingSize!
                        foodItem.householdServingSize = quantity
                        foodItem.servingSize = foodItem.servingSize! * servings
                        for nutrient in self.nutrients {
                            nutrient.value = nutrient.value! * servings
                            nutrient.value = nutrient.value!.truncate(places: 2)
                        }
                        
                        // Save log data & nutrition data to db.
                        NutritionStore.saveDrink(nutrients: self.nutrients)
                        API.Nutrition.saveNutritionLog(food: foodItem, nutrients: self.nutrients, completion: {
                            success in
                            if success {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        })
                        
                    }
                }
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // present the alert into view
        self.present(alertController, animated: true, completion: nil)
    }
}
