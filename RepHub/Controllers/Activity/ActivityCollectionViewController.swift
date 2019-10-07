//
//  ActivityCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ActivityCollectionViewController: UICollectionViewController {
    
    var energyBurnedPerHour : [Int :Double]? = [
        0 : 0.0,
        1 : 0.0,
        2 : 0.0,
        3 : 0.0,
        4 : 0.0,
        5 : 684.2,
        6 : 906.1,
        7 : 677.6,
        8 : 276.6,
        9 : 574.6,
        10 : 433.9,
        11 : 31.8,
        12 : 659.2,
        13 : 135.8,
        14 : 436.4,
        15 : 278.9,
        16 : 707.6,
        17 : 904.8,
        18 : 711.1,
        19 : 394.9,
        20 : 695,
        21 : 491.3,
        22 : 0.0,
        23 : 0.0,
        24 : 0.0,
    ]
    var energyConsumedPerHour : [Int :Double]? = [
        0 : 0.0,
        1 : 0.0,
        2 : 0.0,
        3 : 0.0,
        4 : 0.0,
        5 : 573.5,
        6 : 724.3,
        7 : 604.9,
        8 : 255.9,
        9 : 954.6,
        10 : 297.7,
        11 : 670.8,
        12 : 538.6,
        13 : 987.2,
        14 : 972.1,
        15 : 583.1,
        16 : 689.4,
        17 : 406.1,
        18 : 729.3,
        19 : 764.6,
        20 : 91.6,
        21 : 517,
        22 : 0.0,
        23 : 0.0,
        24 : 0.0,
    ]
    
    var activities : [Activity] = [
        Activity.mind(MindActivity()),
        Activity.exercise(ExerciseActivity()),
        Activity.eat(EatActivity()),
        Activity.hydrate(HydrateActivity())
    ]
    

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
            self.reloadActivities()
        }
    }
    
    private func reloadActivities(){
        self.activities.removeAll()
        self.activities = [
            Activity.mind(MindActivity()),
            Activity.exercise(ExerciseActivity()),
            Activity.eat(EatActivity()),
            Activity.hydrate(HydrateActivity())
        ]
        self.collectionView.reloadData()
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Mind" {}
        else if segue.identifier == "Exercise" {
            let vc = segue.destination as! ExerciseActivityTableViewController
            for activity in self.activities {
                if case .exercise = activity {
                    vc.activity = activity
                }
            }
        }
        else if segue.identifier == "Eat" {
            let vc = segue.destination as! EatActivityTableViewController
            for activity in self.activities {
                if case .eat = activity {
                    vc.activity = activity
                }
            }
        }
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
            //cell.activity = self.activities[indexPath.row]
            cell.message = "Hello!"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityView", for: indexPath) as! ActivityCollectionViewCell
            
            let act = self.activities[indexPath.row]
            switch act {
            case .exercise(let exercise):
                print("Total Steps Ctrl: \(exercise.totalSteps)")
                print("Total Steps Ctrl: \(exercise.standMinutes)")
                break
            default : break
                
            }
            
            cell.activity = self.activities[indexPath.row]
            return cell
        }
    }

}

extension ActivityCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  16
        let collectionViewSize = self.collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize, height: 154)

        
        
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
    
}

extension ActivityCollectionViewController : LifeRingDelegate {
    func segue(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
    
}
