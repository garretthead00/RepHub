//
//  HydrateActivityController.swift
//  RepHub
//
//  Created by Garrett Head on 1/13/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class HydrateActivityController: UITableViewController {

    private let sectionHeaders = ["","Drinks", "","Macros","Electrolytes"]
    
    let drinksByType = [
        "Water": 32.0,
        "Energy": 8.0,
        "Coffee": 24.0,
        "Juice": 12.0
    ]
    
    
    private let macros = [
        ("Protein", 75.0, "g"),
        ("Carbs", 43.0, "g"),
        ("Fat", 35.0, "g"),
    ]
    
    
    private let nutrition = [
        ("Calories",63.0,"cal"),
        ("Drank",56.0,"fl oz"),
        ("Sugar",1.39,"g"),
        ("Alcohol",27.0,"g"),
    ]
    
    
    private let electrolytes = [
        ("Calcium",0.65,"mg"),
        ("Chloride",0.51,"mg"),
        ("Magnesium",1.87,"mg"),
        ("Phosphorus",0.63,"mg"),
        ("Potassium",0.43,"mg"),
        ("Sodium",1.07,"mg"),
    ]
    
    var activity : HydrateActivity? {
        didSet {
            print("got hydrate Activity")
            self.tableView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Hydrate"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.Theme.Activity.hydrate, style: .plain, target: self, action: #selector(goToDrinkMenu))
    }
    
    @objc private func goToDrinkMenu(){
        self.performSegue(withIdentifier: "Drinks", sender: nil)
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
            case 2: rows = self.nutrition.count + 1
            case 3: rows = self.macros.count
            case 4: rows = self.electrolytes.count
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
                cell.progress = self.activity!.dailyTotal
                cell.activityTarget = self.activity!.target
                
                let percentComplete = activity!.percentComplete ?? 0.0
                cell.progressPercent = Int(percentComplete)
                cell.colorTheme = self.activity!.color
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EnergyView", for: indexPath) as! EatActivityEnergyView
                return cell
            }
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinksView", for: indexPath) as! EatActivityMealsView
            return cell
            
        } else if section == 2 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MacroChart", for: indexPath) as! DrinksByTypeView
                cell.drinksByType = self.drinksByType
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MacroDetailView", for: indexPath) as! MacroDetailView
                cell.total = self.nutrition[indexPath.row-1]
                return cell
            }
        } else if section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = self.macros[indexPath.row]
            return cell
        } else if section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = self.electrolytes[indexPath.row]
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
