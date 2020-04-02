//
//  HydrateActivityController.swift
//  RepHub
//
//  Created by Garrett Head on 1/13/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class HydrationController: UITableViewController {

    private let sectionHeaders = ["","Drinks","Macros","Electrolytes", "Other"]
    
    var activity : HydrationActivity?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Hydration"
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
            case 1: rows = 2
            case 2: rows = activity!.macros!.count
            case 3: rows = activity!.electrolytes!.count
            case 4: rows = activity!.otherNutrients!.count
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityLineChartView", for: indexPath) as! ActivityLineChartView
                let waterDrank = activity!.rollingTotal
                cell.hydrationTarget = activity!.target
                cell.waterDrank = waterDrank
                return cell
            }
        } else if section == 1 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MacroChart", for: indexPath) as! DrinksByTypeView
                let drinksByType = activity!.drinksByType
                cell.drinksByType = drinksByType
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityLogCollection", for: indexPath) as! ActivityLogsView
                cell.logs = activity!.hydrationLogs
                return cell
            }
        } else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = activity!.macros![indexPath.row]
            cell.valueLabel.textColor = activity!.color
            return cell
        } else if section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = activity!.electrolytes![indexPath.row]
            cell.valueLabel.textColor = activity!.color
            return cell
        } else if section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            cell.nutrient = activity!.otherNutrients![indexPath.row]
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
            if row == 0 {
                return 228
            } else {
                return 180
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
