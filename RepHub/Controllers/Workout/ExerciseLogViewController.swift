//
//  WorkoutLogViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/22/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol ExerciseLogDelegate {
    func updateTotals(reps: Int?, weight: Double?)
}

class ExerciseLogViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var startExerciseButton: UIButton!
    @IBOutlet weak var startBreakButton: UIButton!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var editExerciseLogsButton: UIButton!
    @IBOutlet weak var addExerciseLogButton: UIButton!
    
    var exerciseId : String?
    var exercise = Exercise()
    var exerciseLogs = [ExerciseLog]()
    var breakOptions = [String]()
    let breakDict = ["15 seconds" : 15, "30 seconds": 30, "45 seconds": 45, "1 minute": 60, "1.5 minutes": 90, "2 minutes": 120, "2.5 minutes": 150, "3 minutes": 180, "5 minutes": 300, "10 minutes" : 600, "15 minutes": 900]
    var selectedBreak = Int()
    var isBreakTimerStarted = false
    var breakTimerSeconds = 0
    var breakTimer = Timer()
    var stopwatchSeconds = 0
    var isStopWatchStarted = false
    var stopWatch = Timer()
    
    var delegate : ExerciseLogDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.updateController()
        self.loadExerciseLogs()
        self.breakOptions = self.sortBreakDict()
        self.selectedBreak = self.breakDict[self.breakOptions[0]]!
        self.navigationItem.rightBarButtonItem?.title = "Edit"
        self.startExerciseButton.setTitleColor(UIColor.white, for: .normal)
        self.startBreakButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    private func sortBreakDict() -> [String] {
        let sortit = self.breakDict.sorted(by: {$0.value < $1.value })
        var arr = [String]()
        for item in sortit {
            arr.append(item.key)
        }
        return arr
    }
    
    private func updateController(){
        API.Exercise.observeExercise(withId: exerciseId!, completion: {
        exercise in
        self.exercise = exercise
        self.exerciseNameLabel.text = self.exercise.name
       })
    }
    
    private func loadExerciseLogs(){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        API.UserExerciseLogs.USER_EXERCISE_LOGS_DB_REF.child(currentUserId).observe(.childAdded, with: {
            snapshot in
//            API.ExerciseLog.obeserveExerciseLogs(withId: snapshot.key , completion: {
//                log in
////                if log.exerciseId == self.exerciseId! {
////                    self.exerciseLogs.insert(log, at: 0)
////                    self.tableview.reloadData()
////                }
//            })
        })
    }
    
    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editExerciseLogs_TouchUpInside(_ sender: Any) {
        if(self.tableview.isEditing == true)
        {
            self.tableview.isEditing = false
            self.editExerciseLogsButton.setTitle("Edit", for: .normal)
        }
        else
        {
            self.tableview.isEditing = true
            self.editExerciseLogsButton.setTitle("Save", for: .normal)
        }
    }
    
    @IBAction func addLogButton_TouchUpInside(_ sender: Any) {
        if let reps = Int(repsTextField.text!) {
           if let weight = Double(weightTextField.text!) {
            self.addExerciseLogButton.isEnabled = false
            let timestamp = Int(Date().timeIntervalSince1970)
            guard let currentUser = API.RepHubUser.CURRENT_USER else {
                return
            }
            let currentUserId = currentUser.uid
            let newExerciseLogRef = API.ExerciseLog.EXERCISE_LOG_DB_REF.childByAutoId()
            newExerciseLogRef.setValue(["exerciseId": self.exerciseId!, "reps": reps, "weightLBS": weight, "timestamp": timestamp, "time-elapsed": self.stopwatchSeconds], withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                API.UserExerciseLogs.USER_EXERCISE_LOGS_DB_REF.child(currentUserId).child(newExerciseLogRef.key!).setValue(true, withCompletionBlock: {
                    error, ref in
                    if error != nil {
                        ProgressHUD.showError(error!.localizedDescription)
                        return
                    }
                    self.delegate?.updateTotals(reps: reps, weight: weight)
                    self.addExerciseLogButton.isEnabled = true
                })
            })
            }
        }
        
    }
    
    @IBAction func startBreak_TouchUpInside(_ sender: Any) {
        if isBreakTimerStarted {
            self.stopBreakTimer()
        } else {
            self.promptBreakTimer()
        }
    }
    
    @IBAction func startStopWatch_TouchUpInside(_ sender: Any) {
        if isStopWatchStarted {
            self.stopStopWatch()
        } else {
            self.startExerciseButton.setTitle("\(self.stopwatchSeconds)", for: .normal)
            self.stopWatch = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateStopWatch), userInfo: nil, repeats: true)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ExerciseLogViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exerciseLogs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Log", for: indexPath)
        let reps = String(describing: self.exerciseLogs[indexPath.row].value!)
        let weight = String(describing: self.exerciseLogs[indexPath.row].weightLB!)
        cell.textLabel?.text = "\(reps) x \(weight)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Recent Logs"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let currentUser = API.RepHubUser.CURRENT_USER else {
                return
            }
            let currentUserId = currentUser.uid
            API.UserExerciseLogs.USER_EXERCISE_LOGS_DB_REF.child(currentUserId).child(self.exerciseLogs[indexPath.row].id!).removeValue(completionBlock: {
                error, ref in
                API.ExerciseLog.EXERCISE_LOG_DB_REF.child(self.exerciseLogs[indexPath.row].id!).removeValue(completionBlock: {
                    error, ref in
                    self.exerciseLogs.remove(at: indexPath.row)
                    self.tableview.reloadData()
                })
            })
        }
    }
    
}

extension ExerciseLogViewController {
    
    // MARK : Stopwatch
    
    private func stopStopWatch(){
        self.stopWatch.invalidate()
        self.stopwatchSeconds = 0
        self.startExerciseButton.setTitle("Start", for: .normal)
        self.isStopWatchStarted = false
    }
    
    // MARK : Break Timer
    
    private func stopBreakTimer(){
        self.selectedBreak = self.breakDict[self.breakOptions[0]]!
        self.breakTimer.invalidate()
        self.breakTimerSeconds = 0
        self.startBreakButton.setImage(UIImage(named: "timer"), for: .normal)
        self.startBreakButton.setTitle(nil, for: .normal)
        self.isBreakTimerStarted = false
    }
    
    private func startBreakTimer(){
        self.startBreakButton.setImage(nil, for: .normal)
        self.startBreakButton.setTitle("\(breakTimerSeconds)", for: .normal)
        self.breakTimerSeconds -= 1
        self.isBreakTimerStarted = true
    }
    
    func promptBreakTimer() {
        let title = "Break"
        let message = "Set the break time limit between sets.\n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.isModalInPopover = true;
        
        let picker = UIPickerView(frame: CGRect(x: 10, y: 60, width: 250, height: 100))
        picker.tag = 0;
        picker.delegate = self;
        picker.dataSource = self;
        
        let startAction = UIAlertAction(title: "Start", style: UIAlertAction.Style.default, handler: ({
            (_) in
            self.breakTimerSeconds = self.selectedBreak
            self.breakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateBreakTimer), userInfo: nil, repeats: true)
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.view.addSubview(picker)
        alert.addAction(startAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func updateBreakTimer(){
        if self.breakTimerSeconds != 0 {
            self.startBreakTimer()
        } else {
            self.stopBreakTimer()
        }
    }
    
    @objc private func updateStopWatch(){
        self.stopwatchSeconds += 1
        self.isStopWatchStarted = true
        self.startExerciseButton.setTitle("\(self.stopwatchSeconds)", for: .normal)
    }
    
    
}

extension ExerciseLogViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breakOptions.count;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    // Return the title of each row in your picker ... In my case that will be the profile name or the username string
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.breakOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBreak = self.breakDict[self.breakOptions[row]]!
    }
}
