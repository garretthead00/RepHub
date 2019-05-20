//
//  HydrateTVC.swift
//  RepHub
//
//  Created by Garrett Head on 5/31/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class HydrateTVC: UITableViewController {
    
    private var drinkPicker : UIPickerView!
    private var drinkPickerSelections = ["Select a Drink", "Water", "Sports Drink", "Juice", "Coffee","Tea", "Beer", "Wine", "Milk", "Shake", "Soda"]
    private var drinkPickerSelection : String!
    private var timePicker : UIPickerView!
    private var timePickerSelections = ["minutes","hours","days"]
    private var timePickerSelection : String!
    private var hydrationSettings : HydrateSettings!
    private var hydrationDailies : HydrateDailies!
    private var hydrationLogs = [HydrateLog]()
    private var percentOfGoal : Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editHydrationSettings))
        self.setupPickers()
        self.loadHydrationLogs()
        self.loadHydrationSettings()
        self.isEditing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      //  self.loadHydrationDailies()
    }


    private func loadHydrationSettings(){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
         API.Hydrate.observeHydrateSettings(withId: currentUserId, completion: {
            settings in
            self.hydrationSettings = settings
            self.tableView.reloadData()
         })
    }

    private func loadHydrationDailies(){
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dateAtMidnight = calendar.startOfDay(for: Date())
        let today = dateAtMidnight.timeIntervalSince1970
        var dailyTotal : Double = 0
        for log in self.hydrationLogs {
            if Int(today) < log.timeStamp! {
                dailyTotal = dailyTotal + log.oz!
            }
        }
        API.Hydrate.updateDailyIntake(withValue: dailyTotal, onSuccess: {
            guard let currentUser = API.RepHubUser.CURRENT_USER else {
                return
            }
            let currentUserId = currentUser.uid
            API.Hydrate.observeHydrateDailies(withId: currentUserId, completion: {
                dailies in
                self.hydrationDailies = dailies
                self.tableView.reloadData()
            })
        })
    }
    
    private func loadHydrationLogs() {
        self.hydrationLogs.removeAll()
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dateAtMidnight = calendar.startOfDay(for: Date())
        let today = dateAtMidnight.timeIntervalSince1970
        var dailyTotal : Double = 0
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        API.Hydrate.USER_HYDRATE_LOGS_DB_REF.child(currentUserId).observe(.childAdded, with: {
            snapshot in
            API.Hydrate.observeHydrateLogs(withId: snapshot.key, completion: {
                log in

                if Int(today) < log.timeStamp! {
                    dailyTotal = dailyTotal + log.oz!
                }
            
                self.hydrationLogs.insert(log, at: 0)
                self.tableView.reloadData()
                API.Hydrate.updateDailyIntake(withValue: dailyTotal, onSuccess: {
                    guard let currentUser = API.RepHubUser.CURRENT_USER else {
                        return
                    }
                    let currentUserId = currentUser.uid
                    API.Hydrate.observeHydrateDailies(withId: currentUserId, completion: {
                        dailies in
                        self.hydrationDailies = dailies
                        self.tableView.reloadData()
                    })
                })
            })
        })

    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 1 {
            return self.hydrationLogs.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat!
        if indexPath.section == 0 { height = 118 }
        else if indexPath.section == 1 { height = 88 }
        else { height = 64 }
        return height

    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title : String!
        if section == 0 {
            title = "Daily Total"
        } else if section == 1 {
            title = "Reminder"
        }
        else {
            title = "Recent Logs"
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Dailies", for: indexPath) as! HydrateDailyTableViewCell
            cell.delegate = self
            cell.dailies = self.hydrationDailies
            cell.isEditing = self.isEditing
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Reminder", for: indexPath) as! HydrateReminderTableViewCell
            cell.settings = self.hydrationSettings
            cell.isEditing = self.isEditing
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLogs", for: indexPath) as! HydrateLogTableViewCell
            let log = self.hydrationLogs[indexPath.row]
            cell.log = log
            return cell
        }
    }

    // Allow only editing rows after section 1.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section > 1 ? .delete : .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            API.Hydrate.removeHydrationLog(withLogId: self.hydrationLogs[indexPath.row].id!, onSuccess: {

                self.loadHydrationLogs()
                self.tableView.reloadData()
                //self.loadHydrationDailies()
            })
        }
    }
    
}

// MARK: - Actions
extension HydrateTVC {
    @IBAction func editHydrationSettings(_ sender: Any) {
        let ip = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: ip) as! HydrateDailyTableViewCell
        if self.isEditing {
            self.isEditing = false
            navigationItem.rightBarButtonItem?.title = "Edit"
            cell.editGoalLabel.isHidden = true
            cell.editGoalTextField.isHidden = true
            cell.hydrationDailyTotalLabel.isHidden = false
            cell.hydrationGoalPercentCompleteLabel.isHidden = false
            if cell.editGoalTextField.text! != "" {
                guard let currentUser = API.RepHubUser.CURRENT_USER else {
                    return
                }
                let currentUserId = currentUser.uid
                let hydrateRef = API.Hydrate.HYDRATE_DB_REF.child(currentUserId)
                let newGoal = Double(cell.editGoalTextField.text!)
                hydrateRef.updateChildValues(["goal": newGoal!], withCompletionBlock: {
                    (error, ref) in
                    self.loadHydrationDailies()
                    self.tableView.reloadData()
                    print("posted to firebase")
                })
            }

        }
        else {
            self.isEditing = true
            navigationItem.rightBarButtonItem?.title = "Save"
            cell.editGoalLabel.isHidden = false
            cell.editGoalTextField.isHidden = false
            cell.hydrationDailyTotalLabel.isHidden = true
            cell.hydrationGoalPercentCompleteLabel.isHidden = true
            self.tableView.reloadData()
        }
        
//        // Establish the AlertController
//        let alertController = UIAlertController(title: "Edit Hydration Settings", message: "\n\n\n\n\n\n", preferredStyle: .alert)
//        alertController.isModalInPopover = true
//        // add
//        alertController.addTextField(configurationHandler: {
//            (textField) in
//            textField.placeholder = "daily goal"
//        })
//        alertController.addTextField(configurationHandler: {
//            (textField) in
//            textField.placeholder = "reminder frequency"
//        })
//        alertController.view.addSubview(timePicker)
//        self.timePickerSelection = ""
//        let confirmAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: ({
//            (_) in
//            if let goalField = alertController.textFields![0] as? UITextField, let frequencyField = alertController.textFields![1] as? UITextField {
//                if goalField.text != "", frequencyField.text != "" {
//                    if !self.timePickerSelection.isEmpty {
//                        guard let currentUser = API.RepHubUser.CURRENT_USER else {
//                            return
//                        }
//                        let currentUserId = currentUser.uid
//                        let hydrateSettingRef = API.Hydrate.HYDRATE_SETTINGS_DB_REF.child(currentUserId)
//                        hydrateSettingRef.updateChildValues(["reminderInterval": self.timePickerSelection, "reminderFrequency":Double(frequencyField.text!)!])
//                        let hydrateRef = API.Hydrate.HYDRATE_DB_REF.child(currentUserId)
//                        hydrateRef.setValue(["goal": Double(goalField.text!)!], withCompletionBlock: {
//                            (error, ref) in
//                            self.tableView.reloadData()
//                            self.loadHydrationData()
//                            print("posted to firebase")
//                        })
//                    }
//                }
//            }
//        }))
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func getPickerIndex(withValue: String) -> Int {
        return self.timePickerSelections.firstIndex(of: withValue)!
    }
}

// MARK: - UIPickerView functions
extension HydrateTVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Initializes the UIPickerViews for the TVC.
    private func setupPickers(){
        drinkPicker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        drinkPicker.dataSource = self
        drinkPicker.delegate = self
        drinkPicker.tag = 0
        
        timePicker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.tag = 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 0 ? self.drinkPickerSelections[row] : self.timePickerSelections[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? self.drinkPickerSelections.count : self.timePickerSelections.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        if pickerView.tag == 0 {
            self.drinkPickerSelection = self.drinkPickerSelections[row]
        } else if pickerView.tag == 1 {
            self.timePickerSelection = self.timePickerSelections[row]
        }
    }
    
}

extension HydrateTVC : HydrateDailiesCellDelegate {
    func addHydrateLog() {
        // Establish the AlertController
        let alertController = UIAlertController(title: "New Hydration Log", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alertController.isModalInPopover = true
        // add
        alertController.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "oz"
        })
        
        self.drinkPicker.selectRow(0, inComponent: 0, animated: true)
        alertController.view.addSubview(drinkPicker)
        self.drinkPickerSelection = ""
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: ({
            (_) in
            if let field = alertController.textFields![0] as? UITextField {
                if field.text != "" {
                    if !self.drinkPickerSelection.isEmpty && self.drinkPicker.selectedRow(inComponent: 0) > 0 {
                        
                        let logReference = API.Hydrate.HYDRATE_LOGS_DB_REF
                        let newLogId = logReference.childByAutoId().key
                        let newLogRef = logReference.child(newLogId)
                        let timestamp = Int(Date().timeIntervalSince1970)
                        newLogRef.setValue(["oz": Double(field.text!)!, "type": self.drinkPickerSelection, "timestamp":timestamp], withCompletionBlock: {
                            (error, ref) in
                            if error != nil {
                                ProgressHUD.showError(error!.localizedDescription)
                                return
                            }
                            
                            guard let currentUser = API.RepHubUser.CURRENT_USER else {
                                return
                            }
                            let currentUserId = currentUser.uid
                            let userHydrateLogsRef = API.Hydrate.USER_HYDRATE_LOGS_DB_REF.child(currentUserId).child(newLogId)
                            userHydrateLogsRef.setValue(true, withCompletionBlock: { (error, ref) in
                                if error != nil {
                                    ProgressHUD.showError(error!.localizedDescription)
                                    return
                                }
                                //self.loadHydrationDailies()
                                self.loadHydrationLogs()
                                self.tableView.reloadData()
                                print("posted to firebase")
                            })
                            
                        })
                    }
                }
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // present the alert into view
        self.present(alertController, animated: true, completion: nil)
    }
    

}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

