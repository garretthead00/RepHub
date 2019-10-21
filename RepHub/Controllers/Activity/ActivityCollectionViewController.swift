//
//  ActivityCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ActivityCollectionViewController: UICollectionViewController {
    
    
    var activities : [Activity] = [
        MindActivity(),
        ExerciseActivity(),
        EatActivity(),
        HydrateActivity()
    ]
    
    var energyBalanceDataHandler : EnergyBalanceDataHandler? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorizeHealthKit()
        self.printData()
        

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
            HealthKitSetupAssistant.authorizeNutritionData {
                (authorized, error) in
                guard authorized else {
                    let baseMessage = "HealthKit Nutrition Authorization Failed"
                    if let error = error {
                        print("\(baseMessage). Reason: \(error.localizedDescription)")
                    } else {
                        print(baseMessage)
                    }
                    return
                }
                print("HealthKit Nutrition Successfully Authorized.")
                
            }
        }
    }
    
    private func printData(){
        let exAct = self.activities[1] as! ExerciseActivity
        let eatAct = self.activities[2] as! EatActivity
        let hydrateAct = self.activities[3] as! HydrateActivity
        let mindAct = self.activities[0] as! MindActivity
        print("----Mind----")
        //print("ActivityCtrl: mindfulMinutes \(mindAct.mindfulMinutes)")
        print("----Exercise----")
        print("-- totalSteps \(exAct.totalSteps)")
        print("-- standMinutes \(exAct.standMinutes)")
        print("-- totalActiveCalories \(exAct.totalActiveCalories)")
        print("----Eat----")
        print("-- totalEnergyConsumed \(eatAct.totalEnergyConsumed)")
        print("-- protein \(eatAct.totalProtein)")
        print("-- fat \(eatAct.totalFat)")
        print("-- carbs \(eatAct.totalCarbohydrates)")
        print("----Hydrate----")
        print("-- water \(hydrateAct.totalWaterDrank)")
        print("-- caffeine \(hydrateAct.totalCaffeine)")
        print("-- sugar \(hydrateAct.totalSugar)")
        
        
        print("-----------")

        print("--consumed")
        print("\(eatAct.todaysCaloriesConsumedPerHour!)")
        print("--burned")
        print("\(exAct.todaysActiveCaloriesBurnedPerHour!)")
        self.energyBalanceDataHandler = EnergyBalanceDataHandler(energyBurned: exAct.todaysActiveCaloriesBurnedPerHour!, energyConsumed: eatAct.todaysCaloriesConsumedPerHour!)
        
        print("energybalance")
        print("\(self.energyBalanceDataHandler?.energyBalance)")
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Mind" {}
        else if segue.identifier == "Exercise" {}
        else if segue.identifier == "Eat" {}
        else if segue.identifier == "Hyrdate" {}
    }
    

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0) ? 1 : self.activities.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnergyBalanceView", for: indexPath) as! EnergyBalanceCollectionViewCell
            cell.message = "Hello!"
            cell.energyBalanceData = self.energyBalanceDataHandler
            return cell
        } else {
            
            if self.activities[indexPath.row].data.count > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityView", for: indexPath) as! ActivityCollectionViewCell
                cell.activity = self.activities[indexPath.row]
                cell.delegate = self
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleActivityView", for: indexPath) as! SimpleActivityCollectionViewCell
                cell.activity = self.activities[indexPath.row]
                cell.delegate = self
                return cell
            }
            

        }
    }

}

extension ActivityCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  16
        let collectionViewSize = self.collectionView.frame.size.width - padding
        if indexPath.section == 0 && indexPath.row == 0 {
            return CGSize(width: collectionViewSize, height: 300)
        } else {
            if self.activities[indexPath.row].data.count > 0 {
               return CGSize(width: collectionViewSize, height: 154)
            } else {
                return CGSize(width: collectionViewSize, height: 100)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            self.performSegue(withIdentifier: self.activities[indexPath.row].label, sender: nil)
        }
    }
    
}

extension ActivityCollectionViewController : ActivityDelegate {
    func segue(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
    
}
