//
//  EatActivityController.swift
//  RepHub
//
//  Created by Garrett Head on 1/10/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class NutritionController: UITableViewController {
    
    private let sectionHeaders = ["", "Macros","Logs", "Lipids","Carbohydrates","Vitamins","Minerals","Ultra-Trace Minerals"]
    
    
    
    var activity : NutritionActivity? {
        didSet {
            
            // filter nutrition logs
            filterNutritionLogs()
            
        }
    }
    
    var nutritionLogs : [NutritionLog] = []
    

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
            case 1: rows = 1 + activity!.macros!.count
            case 2: rows = 1
            case 3: rows = activity!.lipids!.count
            case 4: rows = activity!.carbohydrates!.count
            case 5: rows = activity!.vitamins!.count
            case 6: rows = activity!.minerals!.count
            case 7: rows = activity!.ultraTraceMinerals!.count
            default: rows = 0
        }
        return rows
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityProgressView", for: indexPath) as! ActivityProgressView
                cell.progress = activity?.dailyTotal
                cell.activityTarget = activity?.target
                cell.progressPercent = Int(activity!.percentComplete!)
                cell.colorTheme = self.activity!.color
                return cell          
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityRollingTotal", for: indexPath) as! ActivityRollingTotalView
                let caloriesConsumed = calculateCaloriesConsumedRunningTotal()
                cell.activityTarget = activity!.target
                cell.activityColor = activity!.color
                cell.rollingTotal = caloriesConsumed
               
                return cell
            }
        }
        else if section == 1 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MacroOverview", for: indexPath) as! NutritionActivityMacroOverview
                cell.macros = activity!.macros
                return cell
            } else {
               let cell = tableView.dequeueReusableCell(withIdentifier: "MacroProgressView", for: indexPath) as! NutritionActivity_MacroProgressView
                cell.macro = activity!.macros![indexPath.row-1]
               return cell
           }
        }
        else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityLogCollection", for: indexPath) as! ActivityLogsView
            cell.logs = nutritionLogs
            return cell
        }
        else if section >= 3 && section <= 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientDetailView", for: indexPath) as! NutrientDetailView
            
            switch section {
                case 3: cell.nutrient = activity!.lipids![indexPath.row]
                case 4: cell.nutrient = activity!.carbohydrates![indexPath.row]
                case 5: cell.nutrient = activity!.vitamins![indexPath.row]
                case 6: cell.nutrient = activity!.minerals![indexPath.row]
                case 7: cell.nutrient = activity!.ultraTraceMinerals![indexPath.row]
                default: cell.nutrient = ("",0.0,0.0,"")
            }
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
                return 44
            }
        } else if section == 2 {
            return 180
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

extension NutritionController {
    
    private func filterNutritionLogs(){
        if let activity = self.activity {
            self.nutritionLogs = activity.logs.filter({
                $0.food?.foodGroup != "Drinks"
            })
            self.tableView.reloadData()
        }
        
    }
    
    
    private func calculateCaloriesConsumedRunningTotal()  -> [Double]{
        var totalHydration = [Double]()
        var sum = 0.0
        if let activity = activity {
            for hour in 0...24 {
                let calendar = Calendar.current
                var components = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
                components.hour = hour
                if let startTime = calendar.date(from: components)?.timeIntervalSince1970 {
                    components.hour = hour + 1
                    if let endTime = calendar.date(from: components)?.timeIntervalSince1970 {
                        let logsOnTheHour = activity.logs.filter({
                            $0.timestamp! >= Double(startTime) && $0.timestamp! <= Double(endTime)
                        })
                        for log in logsOnTheHour {
                            if let nutrition = log.nutrition {
                                let energy = nutrition.filter({ $0.name == Nutrients.Energy.rawValue}).first
                                if let calories = energy!.value {
                                    sum += calories
                                }
                                
                            }
                        }
                        totalHydration.append(sum)
                    }
                }
            }
        }
        return totalHydration
    }
    
}
