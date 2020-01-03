//
//  FoodListTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class FoodListTableViewController: UITableViewController {

    private let foodTypesByGroup = FoodItem()
   
    
    var foodGroup : String? {
        didSet {
            self.loadFilters()
        }
    }
    
    var filters : [String]? {
        didSet {
            self.loadFood()
        }
    }
    
    var foods = [FoodItem]()
    var foodsByType = [String : [FoodItem]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    private func loadFilters() {
        self.filters = foodTypesByGroup.foodTypes(byGroup: self.foodGroup!)
        print(self.filters!)
        self.tableView.reloadData()
    }
    
    private func loadFood() {
        let defaultFilterSelection = self.filters![0]
//        API.Food.observeFood(ofGroup: self.foodGroup!, byType: defaultFilterSelection, completion: {
//            food in
//            self.foods.append(food)
//            self.foodsByType = Dictionary(grouping: self.foods, by: { $0.foodGroup! })
//            self.tableView.reloadData()
//        })

        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.foodsByType.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let key = Array(self.foodsByType)[section-1].key
            return self.foodsByType[key]!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodFilter", for: indexPath) as! FoodFilterTableViewCell
            //cell.textLabel?.text = self.filters?.joined(separator: ", ")
            cell.filters = self.filters!
            return cell
        } else {
            let key = Array(self.foodsByType)[indexPath.section-1].key
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItem", for: indexPath)
            cell.textLabel?.text = self.foodsByType[key]![indexPath.row].name
            return cell
        }
        
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > 0 {
            let key = Array(self.foodsByType)[section-1].key
            return key
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 64
        }  else {
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
