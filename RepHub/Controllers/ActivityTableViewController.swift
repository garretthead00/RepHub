//
//  ActivityTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 2/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class ActivityTableViewController: UITableViewController {

    
    var items = ["caloriesBurned", "exerciseMinutes", "distance", "steps", "caloriesConsumed", "hydration", "sleep","caffeine", "sugar", "protein", "fats", "weight"]
    
    //var itemPrimaryColors = []
    //var itemSecondaryColors = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        print("----ACTIVITY TVC -----")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyViewCell", for: indexPath) as! WeeklyViewCell
             print("--WeeklyViewCell")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyViewCell", for: indexPath) as! DailyViewCell
             print("--DailyViewCell")
            return cell
        }
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row % 2 > 0) ? calculateRowHeight(row: indexPath.row) : 248
    }
    
    private func calculateRowHeight(row : Int) -> CGFloat {
        let totalItem: CGFloat = CGFloat(self.items.count)
        let totalCellInARow: CGFloat = 2
        let cellHeight: CGFloat = 132
        
        let collViewTopOffset: CGFloat = 10
        let collViewBottomOffset: CGFloat = 10
        
        let minLineSpacing: CGFloat = 5
        
        // calculations
        let totalRow = ceil(totalItem / totalCellInARow)
        let totalTopBottomOffset = collViewTopOffset + collViewBottomOffset
        let totalSpacing = CGFloat(totalRow - 1) * minLineSpacing   // total line space in UICollectionView is (totalRow - 1)
        return (cellHeight * totalRow) + totalTopBottomOffset + totalSpacing
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
