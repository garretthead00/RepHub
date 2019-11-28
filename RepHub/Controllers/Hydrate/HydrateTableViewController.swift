//
//  HydrateTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import HealthKit

var drinkPickerSelections = ["Select a Drink", "Water", "Sports Drink", "Juice", "Coffee","Tea", "Beer", "Wine", "Milk", "Shake", "Soda"]

class HydrateTableViewController: UITableViewController {

    
    var date : String = ""
    var target : Int = 0
    var score : Int = 0
    var total : Double = 0.0
    var drinkLogs : [String] = []//["Water","Milk","Coffee","Coffee","Tea","Beer", "Wine", "Soda"]
    var logQuantities : [Double] = []
    var reminderFrequency : Int = 0
    var hydrateLogs : [HydrateLog] = []
    
    private var reminderPicker : UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        let image = UIImage(named: "drinkMenu") as UIImage?
        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(x: 16, y: 100, width: 48, height: 48)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(goToDrinkMenu), for:.touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button) //UIBarButtonItem(title: "Drink", style: .plain, target: self, action: #selector(goToDrinkMenu))
        
        self.authorizeHealthKit()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "M/dd/yyyy"
        self.date = dateFormatter.string(from: Date())
    }
    
    
    @objc private func goToDrinkMenu(){
        self.performSegue(withIdentifier: "DrinkMenu", sender: nil)
    }
    
    private func authorizeHealthKit() {
        self.loadHydrationSettings()
        self.fetchHydrationLogs()
//        HealthKitSetupAssistant.authorizeNutritionData {
//            (authorized, error) in
//
//            guard authorized else {
//                let baseMessage = "HealthKit Authorization Failed"
//                if let error = error {
//                    print("\(baseMessage). Reason: \(error.localizedDescription)")
//                } else {
//                    print(baseMessage)
//                }
//                return
//            }
//            print("HealthKit Successfully Authorized.")
//            self.loadHydrationSettings()
//            self.fetchHydrationLogs()
//        }
    }
    
    
    private func loadHydrationSettings(){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        API.Hydrate.observeHydrateSettings(withId: currentUserId, completion: {
            settings in
            if let hydrateTarget = settings.target {
                self.target = hydrateTarget
            }
            if let frequency = settings.frequency {
                self.reminderFrequency = frequency
            }
            self.calculateData()
        })
    }
    
    private func fetchHydrationLogs(){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        API.Hydrate.observeHydrateLogs(withId: currentUserId) {
            log in
            API.Drink.observeDrink(withId: String(log.drinkId!), completion: {
                drink in
                log.drinkName = drink.name!
                log.drinkType = drink.type!
                self.hydrateLogs.append(log)
                self.hydrateLogs = self.hydrateLogs.sorted(by: { $0.timestamp > $1.timestamp})
                self.calculateData()
            })
            
            
        }

    }
    
    private func refreshController(){
        self.score = 0
        self.total = 0
        self.drinkLogs = []
        self.logQuantities = []
         self.fetchHydrationLogs()
    }
    
    private func calculateData(){
        self.total = 0.0
        for logs in self.hydrateLogs {
            self.total += logs.householdServingSize!
        }
        if self.target > 0 {
            let scoreINT = Int((Double(self.total) / Double(self.target)) * 100)
            self.score = scoreINT
        } else {
            self.score = 0
        }

        self.tableView.reloadData()
    }
    
    
    
    @IBAction func targetButton_TouchUpInside(_ sender: Any) {
        self.setTarget()
    }
    
    @IBAction func reminderButton_TouchUpInside(_ sender: Any) {
        self.setReminder()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.hydrateLogs.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HydrateStatusCell", for: indexPath) as! HydrateStatusTableViewCell
            let remaining = (Double(self.target) - self.total) > 0.0 ? (Double(self.target) - self.total) : 0.0
            cell.date = self.date
            cell.total = self.total
            cell.remaining = remaining
            cell.alarmOn = self.reminderFrequency > 0 ? true : false
            cell.score = self.score
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HydrationLogCell", for: indexPath) as! HydrateLogTableViewCell
            print("displaying row with name: \(self.hydrateLogs[row-1].drinkName!)")
            print("val: \(self.hydrateLogs[row-1].householdServingSize!)")
            print("type: \(self.hydrateLogs[row-1].drinkType!)")
            print("unit: \(self.hydrateLogs[row-1].householdServingSizeUnit!)")
            cell.name = self.hydrateLogs[row-1].drinkName!
            cell.quantity = Int(self.hydrateLogs[row-1].householdServingSize!)
            cell.type = self.hydrateLogs[row-1].drinkType!
            cell.unit = self.hydrateLogs[row-1].householdServingSizeUnit!
            return cell
        }
        

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat!
        if indexPath.row == 0 { height = 408 }
        else { height = 66 }
        return height
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 ? false : true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let row = indexPath.row - 1
            
            if let id = self.hydrateLogs[row].id {
                API.Hydrate.removeHydrationLog(withLogId: id, onSuccess: {
                    self.hydrateLogs.remove(at: row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.calculateData()
                    
                })
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            performSegue(withIdentifier: "Results", sender: self.hydrateLogs[indexPath.row-1])
        }
    }
    
 
    
    private func setTarget(){
        // Establish the AlertController
        let alertController = UIAlertController(title: "Hydration Goal (fl oz)", message: "\n", preferredStyle: .alert)
        alertController.isModalInPopover = true
        alertController.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "oz"
        })
        
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: ({
            (_) in
            if let field = alertController.textFields?[0]{
                if field.text != "", let targetINT = Int(field.text!) {
                    self.target = targetINT
                    API.Hydrate.updateHydrationTarget(withValue: targetINT)
                    self.calculateData()
                    
                }
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // present the alert into view
        self.present(alertController, animated: true, completion: nil)
        
    }
    private func setReminder(){
        let alert = UIAlertController(title: "Reminder", message: "hours\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true
        self.reminderPicker = UIPickerView(frame: CGRect(x: 5, y: 48, width: 250, height: 64))
        self.reminderPicker.dataSource = self
        self.reminderPicker.delegate = self
        self.reminderPicker.tag = 0
        self.reminderPicker.clipsToBounds = true
        alert.view.addSubview(self.reminderPicker)
        let confirmAction = UIAlertAction(title: "Set", style: UIAlertAction.Style.default, handler: ({
            (_) in
            let frequencySelectionRow = self.reminderPicker.selectedRow(inComponent: 0)
            self.reminderFrequency = frequencySelectionRow
            API.Hydrate.updateHydrationReminder(withValue: frequencySelectionRow)
            self.tableView.reloadData()
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 168.0)
        alert.view.addConstraint(height)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Results" {
            let drinkResultsTVC = segue.destination as! DrinkResultsTableViewController
            let log = sender as! HydrateLog
            //drinkResultsTVC.log = log
        }
    }
    

}

extension HydrateTableViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 13;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var values = Array(0...12)
        return "\(values[row])"
    }
    
}
