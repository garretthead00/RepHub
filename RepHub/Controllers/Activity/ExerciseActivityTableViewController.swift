//
//  ExerciseActivityTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/19/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ExerciseActivityTableViewController: UITableViewController {
    
    var sectionHeaders = ["","Today's Workout","Daily Activity"]
    var calorieMonitorString = "372/720 calories"

    var activity : Activity? {
        didSet {
            print("ExerciseActivity set...")
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionHeaders.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else {
            return self.activity!.data!.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaders[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieMonitorView", for: indexPath) as! CalorieMonitorTableViewCell
                cell.activity = self.activity
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTrackerView", for: indexPath) as! CalorieTrackerTableViewCell
                cell.activity = self.activity
                return cell
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoWorkoutView", for: indexPath) as! NoWorkoutTableViewCell
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DailyActivityView", for: indexPath) as! DailyActivityTableViewCell
                            //cell.activity = self.activity
                cell.activities = self.activity?.data![indexPath.row]
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyActivityView", for: indexPath) as! DailyActivityTableViewCell
            //cell.activity = self.activity
            cell.activities = self.activity?.data![indexPath.row]
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                return 64
            } else {
                return 300
            }
        } else if section == 1 {
            if row == 0 {
                return 88
            } else {
                return 44
            }
        } else {
            return 44
        }
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
