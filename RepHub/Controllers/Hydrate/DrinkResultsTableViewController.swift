//
//  DrinkResultsTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/29/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class DrinkResultsTableViewController: UITableViewController {


    var drink : FoodItem? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var hydrateLogId : String?

    
    var nutrients : [Nutrient] = [] {
        didSet {
            self.groupNutrients()
        }
    }
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
        let image = UIImage(named: "repeat") as UIImage?
        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(x: 16, y: 100, width: 48, height: 48)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(addTapped), for:.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    

    @objc private func addTapped(){
//        guard let currentUser = API.RepHubUser.CURRENT_USER else {
//            return
//        }
//        let currentUserId = currentUser.uid
//        let drink = Drink()
//        drink.ndb_no = self.log!.drinkId
//        drink.householdServingSize = self.log!.householdServingSize
//        drink.householdServingSizeUnit = self.log!.householdServingSizeUnit
//        drink.servingSize = self.log!.servingSize
//        drink.servingSizeUnit = self.log!.servingSizeUnit
//        NutritionStore.saveDrink(nutrients: self.nutrients)
        //API.Hydrate.saveHyrdationLog(withUserId: currentUserId, drink: drink)
    }
    

    
    private func groupNutrients(){
        self.groupedNutrients = Dictionary(grouping: self.nutrients, by: {
            element in
            return element.category!
        })
        self.tableView.reloadData()
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
            if let drink = self.drink {
                if let name = drink.name {
                    cell.name = name
                }
                if let source = drink.source {
                    cell.nutritionFactsMessage = "**Nutrition Facts provided by \(source)"
                }
                
                if let hhServingSize = drink.householdServingSize, let hhUnit = drink.householdServingSizeUnit, let servingSize = drink.servingSize, let unit = drink.servingSizeUnit {
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
