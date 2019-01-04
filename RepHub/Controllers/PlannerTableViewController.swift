//
//  PlannerTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 7/22/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit
import HealthKit

class PlannerTableViewController: UITableViewController {
    
    private var modules = ["Bio", "Schedule", "Workouts", "Exercises", "Meals", "Hydrate", "Journal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorizeHealthKit()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func authorizeHealthKit() {
        
        HealthKitSetupAssistant.authorizeHealthKit {
            (authorized, error) in
            
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 { return modules.count } else { return 1 }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Recent Activity" : ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: self.modules[indexPath.row], for: indexPath)
            cell.textLabel?.text = self.modules[indexPath.row]
            return cell

        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RecentActivity", for: indexPath) as! PlannerRecentActivityTableViewCell
            return cell
        }
        
    }
    

}
