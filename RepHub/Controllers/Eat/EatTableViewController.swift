//
//  EatTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class EatTableViewController: UITableViewController {
    
    private let controllerSections = ["","Calories","Macros","Monitor","Other","Vitamins","Minerals","Ultratrace Minerals"]
    private let mealImages = ["Breakfast", "Lunch", "Dinner", "Snack"]
    private var caloricTarget = 2000.0
    private var caloriesConsumed = 1240.0
    private var fats = 24.0
    private var protein = 36.0
    private var carbs = 40.0
    private var nutrition = Nutrition()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "foodMenu"), style: .plain, target: self, action: #selector(gotoFoodMenu))
    }
    
    @objc private func gotoFoodMenu(){
    self.performSegue(withIdentifier: "FoodMenu", sender: nil)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.controllerSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section <= 2 {
            return 1
        } else if section == 3 {
            return 1
        } else {
            return nutrition.nutritionDictionary[self.controllerSections[section]]!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return controllerSections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Meal", for: indexPath) as! EatMealsTableViewCell
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieMeter", for: indexPath) as! EatCaloriesTableViewCell
            let caloriesRemaining = caloricTarget - caloriesConsumed
            cell.caloriesConsumed = caloriesConsumed
            cell.caloriesRemaining = caloriesRemaining
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Macros", for: indexPath) as! EatMacrosTableViewCell
            cell.macrosSet = ["fats": self.fats, "carbs": self.carbs, "protein":self.protein]
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Monitor", for: indexPath)
            return cell
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Nutrients", for: indexPath) as! EatNutrientTableViewCell
            cell.nutrientSet = [nutrition.nutritionDictionary[self.controllerSections[indexPath.section]]![indexPath.row] : "0 mg"]
            return cell
           
        }
        
        
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 164
        } else if indexPath.section == 1 {
            return 90
        } else if indexPath.section == 2 {
            return 278
        } else {
            return 44
        }
    }
    

}
