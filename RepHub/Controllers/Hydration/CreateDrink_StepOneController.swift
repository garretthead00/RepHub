//
//  CreateDrink_StepOneController.swift
//  RepHub
//
//  Created by Garrett Head on 1/5/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit


class CreateDrink_StepOneController: UITableViewController {

    
    var sectionHeaders = ["","Serving", "Ingredients", "Nutrition"]
    var name : String?
    var foodGroup: String? = "Drinks"
    var servingSize: Double?
    var servingUnit : String?
    var ingredients = [FoodItem]()
    var nutrients = [Nutrient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func cancel(_ sender: Any) {
        print("next!")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func next(_ sender: Any) {
        // segue to step two controller
        print("next! -- name: \(self.name), foodGroup: \(self.foodGroup), servingSize: \(self.servingSize), servingUnit: \(self.servingUnit)")
        self.performSegue(withIdentifier: "NextStep", sender: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= 1 {
            return 1
        } else if section == 2 {
            if self.ingredients.count > 0 {
                return self.ingredients.count
            } else {
                return 1
            }
            
        } else {
            if self.nutrients.count > 0 {
                return self.nutrients.count
            } else {
                return 1
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameView", for: indexPath) as! CreateDrinkNameView
            cell.delegate = self
            cell.name = self.name
            cell.foodGroup = self.foodGroup
            
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServingView", for: indexPath) as! CreateDrinkServingView
            cell.delegate = self
            cell.servingSize = self.servingSize
            cell.selectedUnit = self.servingUnit
            return cell
        } else if section == 2 {
            
            if self.ingredients.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientView", for: indexPath) as! CreateDrinkIngredientView
                cell.delegate = self
                cell.ingredient = self.ingredients[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddView", for: indexPath) as! CreateDrinkAddItemView
                return cell
            }
            
            
        } else {
            
            if self.nutrients.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientView", for: indexPath) as! CreateDrinkNutrientView
                cell.delegate = self
                cell.nutrient = nutrients[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddView", for: indexPath) as! CreateDrinkAddItemView
                return cell
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
 
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        

        let headerView = UIView()
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 8, y: 8, width: 320, height: 36)
        myLabel.font = UIFont.boldSystemFont(ofSize: 24)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.addSubview(myLabel)
        return headerView
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextStep" {
            let vc = segue.destination as! CreateDrink_StepTwoController
            vc.name = self.name
            vc.foodGroup = self.foodGroup
            vc.servingSize = self.servingSize
            vc.servingUnit = self.servingUnit
            
        }
    }
    

}


extension CreateDrink_StepOneController : CreateFoodDelegate {
    func updateName(name: String) {
        self.name = name
    }
    
    func updateFoodGroup(foodGroup: String) {
        self.foodGroup = foodGroup
    }
    
    func updateIngredients(ingredients: [FoodItem]) {
        self.ingredients = ingredients
    }
    
    func updateNutrients(nutrients: [Nutrient]) {
        self.nutrients = nutrients
    }
    
    func updateUploadImage(image: UIImage) {
    }
    
    func updateDescription(description: String) {
    }
    
    func updateServingSize(serving: Double) {
        self.servingSize = serving
    }
    
    func updateServingUnit(unit: String) {
        self.servingUnit = unit
    }
    
    
}
