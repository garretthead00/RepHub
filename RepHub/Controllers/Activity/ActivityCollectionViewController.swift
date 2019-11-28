//
//  ActivityCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ActivityCollectionViewController: UICollectionViewController {
    
    
    let activityView = UIActivityIndicatorView(style: .whiteLarge)
    
    var activities = [Activity]()
    var energyBurned = [(Date, Double, String)]()
    var energyConsumed = [(Date, Double, String)]()
    var energyBalance = [(Date, Double, String)]()


    override func viewDidLoad() {
        print("ActivityCtrl viewDidLoad")
        super.viewDidLoad()
        
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
        
        print("ActivityCtrl Authenticatine HealthKit")
        self.authorizeHealthKit()
    }
    
    override func viewDidAppear(_ animated: Bool) {

       super.viewDidAppear(animated)

//        let fadeView:UIView = UIView()
//        fadeView.frame = self.view.frame
//        fadeView.backgroundColor = UIColor.white
//        fadeView.alpha = 0.4
//
//        self.view.addSubview(fadeView)

//        self.view.addSubview(activityView)
//        activityView.hidesWhenStopped = true
//        activityView.center = self.view.center
//        activityView.startAnimating()
        
 
        

//       DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
//        fetchPosts()
//       }
//
//       DispatchQueue.main.async {
//        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
//            self.collectionView?.reloadData()
//            self.collectionView?.alpha = 1
//            fadeView.removeFromSuperview()
//            self.activityView.stopAnimating()
//        }, completion: nil)
//     }
    }
    
    
    
    private func authorizeHealthKit() {
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
            print("--HealthKit Successfully Authorized.")
            self.manageActivity()
        }
        

    }
    
    private func manageActivity(){
        print("ActivityCtrl Load Activity")
        self.activities = [
            MindActivity(),
            ExerciseActivity(),
            EatActivity(),
            HydrateActivity()
        ]
        
        print("--- get EnergyBurned")
        ExerciseActivityStore.getHourlyActiveEnergyBurned(){
            result, error in
            guard let result = result else {
                if let error = error {
                    print(error)
                }
                return
            }
            self.energyBurned = result
            print("--- get EnergyConsumed")
            EatActivityStore.getHourlyEnergyConsumedTotal(){
                result, error in
                guard let result = result else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                self.energyConsumed = result
                print("--- get EnergyBalance")
                self.calculateEnergyBalance()
                self.collectionView.reloadData()
                self.activityView.stopAnimating()
            }
        }
        
        
        
    }
    
    private func calculateEnergyBalance(){

        var balanceArray : [(Date, Double, String)] = []
        for i in 0 ..< self.energyBurned.count {
            let difference = self.energyConsumed[i].1 - self.energyBurned[i].1
            balanceArray.append((self.energyBurned[i].0, difference, self.energyBurned[i].2))
        }
        self.energyBalance = balanceArray
        self.collectionView.reloadData()
    }
    

    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Mind" {}
        else if segue.identifier == "Exercise" {
            let destination = segue.destination as! ExerciseActivityTableViewController
            destination.activity = self.activities[1]
        }
        else if segue.identifier == "Eat" {
            let destination = segue.destination as! EatActivityTableViewController
            destination.activity = self.activities[2]
        }
        else if segue.identifier == "Hydrate" {
            let destination = segue.destination as! HydrateActivityTableViewController
            let activity = self.activities[3] as! HydrateActivity
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
                if self.energyBalance.count > 0, self.energyConsumed.count > 0, self.energyBurned.count > 0 {
                    cell.energyBurned = self.energyBurned
                    cell.energyConsumed = self.energyConsumed
                    cell.energyBalance = self.energyBalance
                }
                
                return cell
            } else {
                
                if self.activities[indexPath.row].data.count > 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityView", for: indexPath) as! ActivityCollectionViewCell
                    cell.activity = activities[indexPath.row]
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
