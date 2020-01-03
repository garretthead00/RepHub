//
//  ActivityCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ActivityCollectionViewController: UICollectionViewController {
    
    let activityView = UIActivityIndicatorView(style: .large)
    var energyBalance : EnergyBalanceDataHandler? = EnergyBalanceDataHandler()
    var exerciseActivity : ExerciseActivity? = ExerciseActivity()
    var eatActivity : EatActivity? = EatActivity()
    var hydrateActivity : HydrateActivity? = HydrateActivity()
    var activities = [Activity]() {
        didSet {
            self.refreshController()
        }
    }


    var isHealthKitAuthorized : Bool = false
    

    override func viewDidLoad() {
        print("ActivityCtrl viewDidLoad")
        super.viewDidLoad()
        self.view.addSubview(activityView)
        self.activityView.hidesWhenStopped = true
        self.activityView.center = self.view.center
        self.activityView.startAnimating()
        self.authorizeHealthKit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.collectionView.reloadData()
    }
    
    private func refreshController(){
        
        self.collectionView.reloadData()
    }
    
    
    private func authorizeHealthKit(){
        HealthKitSetupAssistant.authorizeHealthKit {
            (authorized, error) in
            guard authorized else {
                let baseMessage = "--HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            //print("--HealthKit Successfully Authorized.")
            self.isHealthKitAuthorized = true
            self.manageActivity()
            return
        }
        

    }
    
    private func manageActivity(){

        
        print("ActivityCtrl Load Activity")
        if let exercise = self.exerciseActivity, let eat = self.eatActivity, let hydrate = self.hydrateActivity {
            self.activities = [
                exercise,
                eat,
                hydrate
            ]
            self.activityView.stopAnimating()

        }
        self.collectionView.reloadData()
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Exercise" {
            let destination = segue.destination as! ExerciseActivityTableViewController
            destination.activity = self.activities[0]
        }
        else if segue.identifier == "Eat" {
            let destination = segue.destination as! EatActivityTableViewController
            destination.activity = self.activities[1]
        }
        else if segue.identifier == "Hydrate" {
            let destination = segue.destination as! HydrateActivityTableViewController
            let activity = self.activities[2] as! HydrateActivity
            destination.activity = activity
            
        }
    }
    

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0) ? 1 : activities.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnergyBalanceView", for: indexPath) as! EnergyBalanceCollectionViewCell
            if let energyBurned = self.energyBalance?.activeEnergyBurnedByHour, let energyConsumed = self.energyBalance?.energyConsumedByHour, let energyBalance = self.energyBalance?.energyBalanceByHour {
                cell.energyBurned = energyBurned
                cell.energyConsumed = energyConsumed
                cell.energyBalance = energyBalance
            }

            return cell
        } else {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityView", for: indexPath) as! ActivityCollectionViewCell
            cell.activity = activities[indexPath.row]
            cell.delegate = self
            return cell

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
