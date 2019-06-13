//
//  HydrateTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

var drinkPickerSelections = ["Select a Drink", "Water", "Sports Drink", "Juice", "Coffee","Tea", "Beer", "Wine", "Milk", "Shake", "Soda"]

class HydrateTableViewController: UITableViewController {

    
    var date : String = "6/13/2019"
    var target : Int = 0
    var score : Int = 0
    var total : Int = 0
    var drinkLogs : [String] = ["Water","Milk","Coffee","Coffee","Tea","Beer", "Wine", "Soda"]
    var logQuantities : [Int] = [12,8,8,8,12,12,6,8]
    var reminderFrequency : Int = 0
    
    private var reminderPicker : UIPickerView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateData()
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
            cell.targetStr = "\(total) / \(target) oz"
            cell.score = self.score
            print("date: \(date) target: \(target) score: \(score)")
            cell.alarmOn = self.reminderFrequency > 0 ? true : false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HydrationLogCell", for: indexPath) as! HydrateLogTableViewCell
            cell.name = self.drinkLogs[row - 1]
            cell.quantity = self.logQuantities[row - 1]
            print("drink: \(self.drinkLogs[row - 1]) quantity: \(self.logQuantities[row - 1])")
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
        let alertController = UIAlertController(title: "New Hydration Log", message: "\n", preferredStyle: .alert)
        alertController.isModalInPopover = true
        alertController.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "oz"
        })
        
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: ({
            (_) in
            if let field = alertController.textFields![0] as? UITextField {
                if field.text != "", let intText = Int(field.text!) {
                    self.target = intText
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
