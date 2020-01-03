//
//  HydrateActivityTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 11/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class HydrateActivityTableViewController: UITableViewController {
    
    var activity : HydrateActivity? {
        didSet {
            print("activity set")
            self.tableView.reloadData()
        }
    }
    
    var hydrateActivity : HydrateActivity? {
        didSet {
            print("hydrateActivity set")
            self.tableView.reloadData()
        }
    }
    

    var hydrateLogs : [HydrateLog] = []
    var totalDrankByDrinkType : [(String, Double)] = []

    var drinkDict = [String : Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drinks"), style: .plain, target: self, action: #selector(goToDrinkMenu))
        //self.fetchHydrationLogs()
    }
    
    @objc private func goToDrinkMenu(){
        self.performSegue(withIdentifier: "Drinks", sender: nil)
    }
    
    
//    private func fetchHydrationLogs(){
//        guard let currentUser = API.RepHubUser.CURRENT_USER else {
//            return
//        }
//        let currentUserId = currentUser.uid
//        API.Hydrate.observeHydrateLogs(withId: currentUserId) {
//            log in
//            self.hydrateLogs.append(log)
//            self.hydrateLogs = self.hydrateLogs.sorted(by: { $0.timestamp > $1.timestamp})
//            print("hydrate log -- : \(log)")
//            self.calculateTotalDrankByDrinkType()
//            self.activity?.logs = self.hydrateLogs
//            self.tableView.reloadData()
//        }
//
//    }
    
    private func calculateTotalDrankByDrinkType(){
//        let allKeys = Set<String>(self.hydrateLogs.filter({!$0.drinkType!.isEmpty}).map{$0.drinkType!})
//        
//        for key in allKeys {
//            let sum = self.hydrateLogs.filter({$0.drinkType! == key}).map({$0.servingSize!}).reduce(0, +)
//            self.totalDrankByDrinkType.append((key, sum))
//            print("totalDrankBydrinkType -- \(self.totalDrankByDrinkType)")
//            self.drinkDict[key] = sum
//            print("drinkDict -- \(self.drinkDict)")
//            
//        }
        
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 2
        } else if section == 1 {
            return self.activity?.data.count ?? 0
        } else {
            return self.hydrateLogs.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressView", for: indexPath) as! CalorieMonitorTableViewCell
                //cell.activity = self.activity
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChartView", for: indexPath) as! HydrateChartTableViewCell
                //cell.activity = self.activity
                cell.drinksByType = self.drinkDict
                return cell
            }
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyActivityView", for: indexPath) as! DailyActivityTableViewCell
            cell.activities = self.activity?.data[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HydrationLogView", for: indexPath) as! HydrateLogTableViewCell
//            cell.name = self.hydrateLogs[row].drinkName!
//            cell.quantity = Int(self.hydrateLogs[row].householdServingSize!)
//            cell.type = self.hydrateLogs[row].drinkType!
//            cell.unit = self.hydrateLogs[row].householdServingSizeUnit!
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
        } else {
            return 44
        }
        

    
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else if section == 1 {
            return "Daily Totals"
        } else {
            return "Recent Logs"
        }
    }
    

    
    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Drinks" {
//            let destination = segue.destination as! DrinksController
//            destination.navigationItem.largeTitleDisplayMode = .always
//        }
//        
//
//    }
    

}
