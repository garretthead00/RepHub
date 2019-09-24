//
//  EatActivityTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit




class EatActivityTableViewController: UITableViewController {

    var sectionHeaders = ["","Today's Meals","Daily Activity"]
    
    
    var activity : Activity? {
        didSet {
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
            return 0//self.eatActivity.count //+ 1
        } else {
            return 0//self.dailyActivity.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyActivityView", for: indexPath) as! DailyActivityTableViewCell
            cell.activity = self.activity
            return cell
//            if indexPath.row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Meals", for: indexPath) as! NoWorkoutTableViewCell
//                return cell
//            }
//            else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "DailyActivityView", for: indexPath) as! DailyActivityTableViewCell
//                cell.dataSet = self.eatActivity[indexPath.row-1]
//                return cell
//            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyActivityView", for: indexPath) as! DailyActivityTableViewCell
            cell.activity = self.activity
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
//            if row == 0 {
//                return 88
//            } else {
//                return 44
//            }
            return 44
        } else {
            return 44
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
