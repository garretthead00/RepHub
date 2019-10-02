//
//  ActivityCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ActivityCollectionViewController: UICollectionViewController {

    let mealLogs = [0.0,0.0,0.0,0.0,0.0,0.0,5.0,0.0,0.0,0.0,5.0,0.0,0.0,0.0,10.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    let exerciseLogs = [0.0,0.0,0.0,0.0,0.0,0.0,56.0,23.0,43.0,42.0,36.0,123.0,154.0,34.0,10.0,15.0,23.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    let eatLogs = [0.0,0.0,0.0,0.0,0.0,0.0,123.0,0.0,0.0,42.0,0.0,520.0,154.0,0.0,0.0,0.0,230.0,0.0,684.0,0.0,0.0,0.0,0.0,0.0]
    let hydrateLogs = [0.0,0.0,0.0,0.0,0.0,0.0,12.0,24.0,0.0,8.0,8.0,0.0,0.0,0.0,12.0,0.0,8.0,16.0,0.0,0.0,0.0,0.0,0.0,0.0]
    
    var mindActivity : Activity?
    var exerciseActivity : Activity?
    var eatActivity : Activity?
    var hydrateActivity : Activity?
    
    var activities : [Activity]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var activity : Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadActivity()
    }
    
    private func loadActivity(){
        self.mindActivity = Activity.mind(MindActivityData(logs: self.mealLogs))
        self.exerciseActivity = Activity.exercise(ExerciseActivity(logs: self.exerciseLogs))
        self.eatActivity = Activity.eat(EatActivityData(logs: self.eatLogs))
        self.hydrateActivity = Activity.hydrate(HydrateActivityData(logs: self.hydrateLogs))
        self.activities = [self.mindActivity!, self.exerciseActivity!, self.eatActivity!, self.hydrateActivity!]
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Mind" {}
        else if segue.identifier == "Exercise" {
            let vc = segue.destination as! ExerciseActivityTableViewController
            vc.activity = self.exerciseActivity
        }
        else if segue.identifier == "Eat" {
            let vc = segue.destination as! EatActivityTableViewController
            vc.activity = self.eatActivity
        }
        else if segue.identifier == "Hyrdate" {}
    }
    

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activities!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeRing", for: indexPath) as! LifeRingCollectionViewCell
            cell.activity = self.activities![indexPath.row]
            cell.delegate = self

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeData", for: indexPath) as! LifeDataCollectionViewCell
            cell.activity = self.activities![indexPath.row]
            return cell
        }
        
    }

}

extension ActivityCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let padding: CGFloat =  16
            let collectionViewSize = self.collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: 132)
        } else {
            let padding: CGFloat =  16
            let collectionViewSize = self.collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize, height: 128)
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
    
}

extension ActivityCollectionViewController : LifeRingDelegate {
    func segue(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
    
    
    
    
}
