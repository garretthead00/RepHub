//
//  EatActivityController.swift
//  RepHub
//
//  Created by Garrett Head on 1/10/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class NutritionController: UITableViewController {
    
    private let sectionHeaders = ["","Meals", "Macros","Lipids","Carbohydrates","Vitamins","Minerals","Ultra-Trace Minerals"]
    
    private let macros = [
        ("Protein",20.0, 75.0, "g"),
        ("Carbs",20.0, 43.0, "g"),
        ("Fat",20.0, 35.0, "g"),
    ]
    
    private let lipids = [
        ("Monounsaturated Fat",20.0,1.2,"g"),
        ("Polyunsaturated Fat",20.0,1.59,"g"),
        ("Saturated Fat",20.0,0.57,"g"),
        ("Cholesterol",20.0,0.88,"g"),
    ]
    
    private let carbohydrates = [
        ("Fiber",20.0,0.75,"g"),
        ("Sugar",20.0,1.39,"g"),
    ]
    
    
    private let vitamins = [
        ("Folate",20.0,0.45,"mg"),
        ("Vitamin A",20.0,0.53,"mcg"),
        ("Vitamin B1",20.0,1.78,"mg"),
        ("Vitamin B12",20.0,1.05,"mg"),
        ("Vitamin B2",20.0,1.33,"mg"),
        ("Vitamin B3",20.0,0.14,"mg"),
        ("Vitamin B5",20.0,1.75,"mg"),
        ("Vitamin B6",20.0,1.2,"mg"),
        ("Vitamin B7",20.0,1.35,"mg"),
        ("Vitamin C",20.0,0.39,"mg"),
        ("Vitamin D",20.0,1.47,"mcg"),
        ("Vitamin E",20.0,0.09,"mg"),
        ("Vitamin K",20.0,1.34,"mg"),
    ]
    
    private let minerals = [
        ("Calcium",20.0,0.65,"mg"),
        ("Chloride",20.0,0.51,"mg"),
        ("Iron",20.0,0.03,"mg"),
        ("Magnesium",20.0,1.87,"mg"),
        ("Phosphorus",20.0,0.63,"mg"),
        ("Potassium",20.0,0.43,"mg"),
        ("Sodium",20.0,1.07,"mg"),
        ("Zinc",20.0,1.13,"mg"),
    ]
    private let utlraTraceMinerals = [
        ("Chromium",20.0,1.66,"mg"),
        ("Copper",20.0,0.54,"mg"),
        ("Iodine",20.0,0.77,"mcg"),
        ("Manganese",20.0,0.68,"mg"),
        ("Molybdenum",20.0,0.18,"mg"),
        ("Selenium",20.0,1.32,"mcg"),
    ]
    
    
    var activity : NutritionActivity? {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Nutrition"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.Theme.Activity.eat, style: .plain, target: self, action: #selector(goToFoodMenu))
    }
    
    @objc private func goToFoodMenu(){
        self.performSegue(withIdentifier: "Food", sender: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionHeaders.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch section {
            case 0 : rows = 2
            case 1: rows = 1
            case 2: rows = self.macros.count + 1
            case 3: rows = self.lipids.count
            case 4: rows = self.carbohydrates.count
            case 5: rows = self.vitamins.count
            case 6: rows = activity!.minerals!.count
            case 7: rows = self.utlraTraceMinerals.count
            default: rows = 0
        }
        return rows
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressView", for: indexPath) as! ActivityProgressView
                cell.progress = activity?.dailyTotal
                cell.activityTarget = activity?.target
                cell.progressPercent = Int(activity!.percentComplete!)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EnergyView", for: indexPath) as! EatActivityEnergyView
                return cell
            }
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealsView", for: indexPath) as! EatActivityMealsView
            return cell
            
        } else if section == 2 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MacroChart", for: indexPath) as! MacroChartView
                cell.protein = 35.0
                cell.fats = 13.0
                cell.carbs = 22.0
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MacroDetailView", for: indexPath) as! MacroDetailView
                cell.total = activity?.macros![indexPath.row-1]
                return cell
            }
        } else if section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = self.lipids[indexPath.row]
            cell.valueLabel.textColor = activity!.color
            return cell
        } else if section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = self.carbohydrates[indexPath.row]
            cell.valueLabel.textColor = activity!.color
            return cell
        } else if section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = self.vitamins[indexPath.row]
            cell.valueLabel.textColor = activity!.color
            return cell
        } else if section == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = self.minerals[indexPath.row]
            cell.valueLabel.textColor = activity!.color
            return cell
        } else if section == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = self.utlraTraceMinerals[indexPath.row]
            cell.valueLabel.textColor = activity!.color
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataView", for: indexPath) as UITableViewCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                return 57
            } else {
                return 228
            }
        } else if section == 1 {
            return 80
        } else if section == 2 {
            if row == 0 {
                return 228
            } else {
                return 44
            }
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaders[section]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
