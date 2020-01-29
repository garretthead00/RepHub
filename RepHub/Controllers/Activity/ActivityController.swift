//
//  ActivityController.swift
//  RepHub
//
//  Created by Garrett Head on 1/24/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class ActivityController: UITableViewController {
    
    var activitySummary : String?
    var summaryData = [(String, Double, String)]()
    var exerciseActivity : newExerciseActivity?
    var exerciseData = [(String, Double, String)]()
    var nutritionActivity : EatActivity?
    var nutritionData = [(String, Double, String)]()
    var hydrationActivity : HydrateActivity?
    var hydrationData = [(String, Double, String)]()
    var hydrationLogs = [HydrateLog](){
        didSet {
            self.updateActivities()
        }
    }
    var activities = [Activity]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summaryData = [("sleep", 495.0, "min"),("mindfulness", 12.0, "min"),("weight", 176.0, "lbs")]
        self.fetchExerciseActivity()
        self.fetchNutritionActivity()
        self.fetchHydrationActivity()
        
        // HK Authentication
    }
    
    private func updateActivities(){
        
        
        
        self.activities.removeAll()
        if let exercise = self.exerciseActivity {
            self.activities.append(exercise)
        }
        
        if let nutrition = self.nutritionActivity {
            self.activities.append(nutrition)
        }
        
        if self.hydrationActivity != nil {
            self.hydrationActivity!.refreshLogs(logs: self.hydrationLogs)
            self.activities.append(self.hydrationActivity!)
            
            if let caffeine = self.hydrationActivity?.totalCaffeine, let fluids = self.hydrationActivity?.totalFluids, let sugar = self.hydrationActivity?.totalSugar, let water = self.hydrationActivity?.totalWater {
                self.hydrationActivity!.dailyTotal = water
                self.hydrationData = [("caffeine", caffeine, "mg"),("sugar", sugar, "g"),("total drank", fluids, "oz")]
            }
        }
        

        
        self.tableView.reloadData()
    }
    
    private func fetchExerciseActivity(){
        self.exerciseActivity = newExerciseActivity()
        self.exerciseData = [("workouts", self.exerciseActivity!.workoutsCompleted, ""),("steps", self.exerciseActivity!.totalSteps, ""),("exercise minutes", self.exerciseActivity!.exerciseMinutes, "min")]
        self.updateActivities()
        
    }
    
    private func fetchNutritionActivity(){
        self.nutritionActivity = EatActivity()
        self.nutritionData = [("protein", self.nutritionActivity!.protein, "g"),("carbohydrates", self.nutritionActivity!.carbohydrates, "g"),("fats", self.nutritionActivity!.fats, "g")]
        self.updateActivities()
        
    }
    
    private func fetchHydrationActivity(){
        self.hydrationActivity = HydrateActivity(logs: self.hydrationLogs)
        self.updateActivities()
        API.Hydrate.dispatchHydrationLogs(completion: {
            log in
            self.hydrationLogs.append(log)
            
            //self.updateActivities()
        })
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.activities.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.summaryData.count + 1
        } else if section == 1 {
            return self.exerciseData.count + 1
        } else if section == 2 {
            return self.nutritionData.count + 1
        } else {
            return self.hydrationData.count + 1
        }
            
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryView", for: indexPath) as! ActivitySummaryView
                cell.date = Date()
                cell.temperature = "72 F"
                cell.weatherCondition = "partlyCloudyDay"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DataView", for: indexPath) as! ActivityDataView
                cell.data = self.summaryData[indexPath.row - 1]
                return cell
            }
        } else {
             if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityView", for: indexPath) as! ActivityView
                let activity = self.activities[section - 1]
                cell.name = activity.name
                cell.iconImage = activity.icon
                cell.total = activity.dailyTotal
                cell.remaining = activity.remainingToTarget
                cell.unit = activity.unit
                cell.color = activity.color
                 return cell
             } else if section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DataView", for: indexPath) as! ActivityDataView
                cell.data = self.exerciseData[indexPath.row - 1]
                return cell
             } else if section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DataView", for: indexPath) as! ActivityDataView
                cell.data = self.nutritionData[indexPath.row - 1]
                return cell
             } else {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "DataView", for: indexPath) as! ActivityDataView
                 cell.data = self.hydrationData[indexPath.row - 1]
                 return cell
             }
        }
               
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                return 135
            } else {
                return 44
            }
        } else {
            if row == 0 {
                return 170
            } else {
                return 44
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section > 0 {
            self.performSegue(withIdentifier: self.activities[section - 1].name, sender: nil)
        }
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Exercise" {
            let destination = segue.destination as! ExerciseActivityTableViewController
            destination.activity = self.activities[0]
        }
        else if segue.identifier == "Nutrition" {
            let destination = segue.destination as! EatActivityController
            //destination.activity = self.activities[1]
        }
        else if segue.identifier == "Hydration" {
            let destination = segue.destination as! HydrateActivityController
            let activity = self.activities[2] as! HydrateActivity
            destination.activity = activity
            
        }
    }
    

}

