//
//  ActivityCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ActivityCollectionViewController: UICollectionViewController {
    
    
    var mindActivity : MindActivity? {
        didSet {
            self.manageEnergyBalance()
        }
    }
    var exerciseActivity : ExerciseActivity? {
        didSet {
            self.manageEnergyBalance()
        }
    }
    var eatActivity : EatActivity? {
        didSet {
            self.manageEnergyBalance()
        }
    }
    var hydrateActivity : HydrateActivity? {
        didSet {
            self.manageEnergyBalance()
        }
    }
    
    
    var activities : [Activity] = [] {
        didSet {
            
            self.collectionView.reloadData()
        }
    }
        
    
    var energyBalanceDataHandler : EnergyBalanceDataHandler? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorizeHealthKit()
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
                self.manageActivity()
                
            }
            
        }
        

    }
    
    private func manageActivity(){
        self.mindActivity = MindActivity()
        self.exerciseActivity = ExerciseActivity()
        self.eatActivity = EatActivity()
        self.hydrateActivity = HydrateActivity()
        if let mind = self.mindActivity, let exercise = self.exerciseActivity, let eat = self.eatActivity, let hydrate = self.hydrateActivity {
            self.activities.append(mind)
            self.activities.append(exercise)
            self.activities.append(eat)
            self.activities.append(hydrate)

        }

    }
    
    
    private func manageEnergyBalance(){
        if let exercise = self.exerciseActivity, let eat = self.eatActivity {
            if let energyBurned = exercise.todaysActiveCaloriesBurnedPerHour, let energyConsumed = eat.todaysCaloriesConsumedPerHour {
                self.energyBalanceDataHandler = EnergyBalanceDataHandler(energyBurned: energyBurned, energyConsumed: energyConsumed)
                print("--burned")
                print("\(energyBurned)")
                print("--consumed")
                print("\(energyConsumed)")
//                print("energybalance")
//                print("\(self.energyBalanceDataHandler?.energyBalance)")
            }
        }
        
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
            cell.energyBalanceData = self.energyBalanceDataHandler
            return cell
        } else {
            
            if self.activities[indexPath.row].data.count > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityView", for: indexPath) as! ActivityCollectionViewCell
                cell.activity = self.activities[indexPath.row]
                //cell.delegate = self
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
