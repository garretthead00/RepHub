//
//  DrinkNutritionTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class DrinkTableViewController: UITableViewController {

    var drink : Drink? {
        didSet {
            self.loadNutritionFacts()
        }
        
    }
    
    var drinkType : String?
    
    var nutrients : [Nutrient] = []
    var groupedNutrients : [String : [Nutrient]] = [:]
    var nutrientGroupName = ["","Macronutrients","Vitamins","Minerals","Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Drink", style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc private func addTapped(){
        self.addLog()
    }
    private func addLog(){
        let alertController = UIAlertController(title: self.drink!.name!, message: "\n", preferredStyle: .alert)
        alertController.isModalInPopover = true
        alertController.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "fl oz" //self.drink!.householdServingSizeUnit!
        })
        
        let confirmAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: ({
            (_) in
            if let field = alertController.textFields?[0] {
                if field.text != "", let quantity = Double(field.text!) {
                    if let drink = self.drink {
                        guard let currentUser = API.RepHubUser.CURRENT_USER else {
                            return
                        }
                        let currentUserId = currentUser.uid
                        //let nutritionWeight = quantity / drink.householdServingSize!
                        drink.householdServingSize = quantity
                        drink.servingSize = quantity//drink.servingSize! * nutritionWeight
//                        for nutrient in self.nutrients {
//                            nutrient.value = nutrient.value! * nutritionWeight
//                            nutrient.value = nutrient.value!.truncate(places: 2)
//                        }
//                        NutritionStore.saveDrink(nutrients: self.nutrients)
                       // API.Hydrate.saveHyrdationLog(withUserId: currentUserId, drink: self.drink!)
                        
                        if let type = self.drinkType, let drink = self.drink {
                            API.Hydrate.saveHydrationLog(ofDrinkType: type, userId: currentUserId, drink: drink)
                        }
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
    
    
    private func loadNutritionFacts(){
        if let drink = self.drink, let id = drink.ndb_no {
            let idStr = String(id)
            API.Nutrient.observeNutrition(withId: idStr, completion: {
                nutrient in
                
                self.nutrients.append(nutrient)
                self.groupNutrients(nutrients: self.nutrients)
            })
      
        }
    }
    
    private func groupNutrients(nutrients: [Nutrient]){
//        self.groupedNutrients = Dictionary(grouping: nutrients, by: {
//            element in
//            return nutritionDictionary[element.name!]!
//        })
        self.tableView.reloadData()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedNutrients.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nutrientGroup = self.nutrientGroupName[section]
        if let nutrients = self.groupedNutrients[nutrientGroup] {
            let count = nutrients.count
            return count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.nutrientGroupName[section]
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
                if let date = drink.dateAvailable, let manufacturer = drink.manufacturer {
                    cell.nutritionFactsMessage = "**Nutrition Facts provided by \(manufacturer) \(date)"
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
    
    
 

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
