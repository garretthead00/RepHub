//
//  DrinkResultsTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/29/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class DrinkResultsTableViewController: UITableViewController {

    
    var log : HydrateLog? {
        didSet {
            self.loadNutritionFacts()
        }
        
    }
    var nutrients : [Nutrient] = []
    var groupedNutrients : [String : [Nutrient]] = [:]
    var nutrientGroupName = ["","Macronutrients","Vitamins","Minerals","Other"]
    
    
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
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        let drink = Drink()
        drink.ndb_no = self.log!.drinkId
        drink.householdServingSize = self.log!.householdServingSize
        drink.householdServingSizeUnit = self.log!.householdServingSizeUnit
        drink.servingSize = self.log!.servingSize
        drink.servingSizeUnit = self.log!.servingSizeUnit
        NutritionStore.saveDrink(nutrients: self.nutrients)
        API.Hydrate.saveHyrdationLog(withUserId: currentUserId, drink: drink)
    }
    
    private func loadNutritionFacts(){
        

        if let log = self.log, let id = log.drinkId {
            let idStr = String(id)
            
            API.Drink.observeDrink(withId: idStr, completion: {
                drink in
                let nutritionWeight = log.servingSize! / drink.servingSize!
                log.drinkName = drink.name!
                log.drinkType = drink.type!
                API.Nutrient.observeNutrition(withId: idStr, completion: {
                    nutrient in
                    nutrient.value = nutrient.value! * nutritionWeight
                    nutrient.value = nutrient.value!.truncate(places: 2)
                    self.nutrients.append(nutrient)
                    self.groupNutrients(nutrients: self.nutrients)
                })
                
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
            if let log = self.log {
                if let name = log.drinkName {
                    cell.name = name
                }
//                if let timeStamp = log.timestamp {
//                    let date = Date(timeIntervalSince1970: timeStamp)
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "M/d/yyyy h:m a"
//                    dateFormatter.amSymbol = "AM"
//                    dateFormatter.pmSymbol = "PM"
//                    let dateStr = dateFormatter.string(from: date)
//                    cell.nutritionFactsMessage = "\(dateStr)"
//                }
                let date = Date(timeIntervalSince1970: log.timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "M/d/yyyy h:m a"
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                let dateStr = dateFormatter.string(from: date)
                cell.nutritionFactsMessage = "\(dateStr)"
                
                if let hhServingSize = log.householdServingSize, let hhUnit = log.householdServingSizeUnit, let servingSize = log.servingSize, let unit = log.servingSizeUnit {
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
