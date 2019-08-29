//
//  FoodMenuTableViewController.swift
//  Charts
//
//  Created by Garrett Head on 8/28/19.
//

import UIKit

class FoodMenuTableViewController: UITableViewController {

    private var menuItems : [String] = ["Meals", "Food", "Drinks", "Supplements"]
    private var sectionNames : [String] = ["","Recent Logs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Menu"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sectionNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return self.menuItems.count
        } else {
            return 2
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath) as! FoodMenuItemTableViewCell
            cell.title = self.menuItems[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLog", for: indexPath)
            cell.textLabel?.text = "Log \(indexPath.row)"
            return cell
        }

    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 80
        }  else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Food", sender: nil)
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
