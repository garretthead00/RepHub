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

    
    var date : String = "6/13/2019"
    var target : Int = 0
    var score : Int = 0
    var total : Int = 0
    var drinkLogs : [String] = []//["Water","Milk","Coffee","Coffee","Tea","Beer", "Wine", "Soda"]
    var logQuantities : [Int] = []
    var reminderFrequency : Int = 0
    
    private var reminderPicker : UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Drink", style: .plain, target: self, action: #selector(goToDrinkMenu))
        self.authorizeHealthKit()
    }
    
    @objc private func goToDrinkMenu(){
        self.performSegue(withIdentifier: "DrinkMenu", sender: nil)
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
    
    private func authorizeHealthKit() {
        
        HealthKitSetupAssistant.authorizeNutritionData {
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
            self.loadHydrationSettings()
            self.fetchHydrationLogs()
        }
    }
    
    
    private func fetchHydrationLogs(){
        NutritionStore.fetchHydrationLogs(completion: {
            (samples, error) in
            guard let samples = samples else {
                if let error = error {
                    print(error)
                }
                return
            }
            for sample in samples {
                let quantityInFluidOunces = sample.quantity.doubleValue(for: HKUnit.fluidOunceUS())
                let quantityInt = Int(quantityInFluidOunces)
                self.drinkLogs.append("Water")
                self.logQuantities.append(quantityInt)
                self.calculateData()
            }

        })
    }
    
    private func refreshController(){
        self.score = 0
        self.total = 0
        self.drinkLogs = []
        self.logQuantities = []
         self.fetchHydrationLogs()
    }
    
    private func calculateData(){
        self.total = 0
        for quantity in self.logQuantities {
            self.total += quantity
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
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "DrinkMenu" {
//            let drinkCVC = segue.destination as! DrinkMenuCollectionViewController
//        }
//
//     }
 

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.drinkLogs.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HydrateStatusCell", for: indexPath) as! HydrateStatusTableViewCell
            cell.date = self.date
            cell.targetStr = "\(total) / \(self.target) oz"
            cell.score = self.score
            cell.alarmOn = self.reminderFrequency > 0 ? true : false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HydrationLogCell", for: indexPath) as! HydrateLogTableViewCell
            cell.name = self.drinkLogs[row - 1]
            cell.quantity = self.logQuantities[row - 1]
            return cell
        }
        

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat!
        if indexPath.row == 0 { height = 273 }
        else { height = 66 }
        return height
        
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
