//
//  EatTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class EatTableViewController: UITableViewController {
    
    private var mealImages = ["Breakfast", "Lunch", "Dinner", "Snack"]
    private var calorieString = "782 / 1850 cals"

    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Meal", for: indexPath) as! EatMealsTableViewCell
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieMeter", for: indexPath) as! EatCaloriesTableViewCell
            cell.title = "Calories"
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Macros", for: indexPath) as! EatMacrosTableViewCell
            cell.title = "Macros"
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Vitamins", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Minerals", for: indexPath)
            return cell
        }
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 164
        } else if indexPath.row == 1 {
            return 90
        } else if indexPath.row == 2 {
            return 278
        } else {
            return 44
        }
    }

}
