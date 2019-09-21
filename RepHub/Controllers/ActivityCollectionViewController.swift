//
//  ActivityCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ActivityCollectionViewController: UICollectionViewController {

    var activity : [Activity]? {
        didSet {
            print("got activity")
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        print("ActivityCtrl ViewDidLoad")
        super.viewDidLoad()
        self.loadActivity()
    }
    
    private func loadActivity(){
        let mind = Activity.mind(MindActivityData(dailyTotal: 23.0, target: 30))
        let exercise = Activity.exercise(ExerciseActivityData(dailyTotal: 532.0, target: 720.0))
        let eat = Activity.eat(EatActivityData(dailyTotal: 757.0, target: 1750.0))
        let hydrate = Activity.hydrate(HydrateActivityData(dailyTotal: 54.0, target: 64.0))
        self.activity = [mind, exercise, eat, hydrate]
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activity!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let activityData : ActivityData? = ActivityData(activity: self.activity![indexPath.row])
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeRing", for: indexPath) as! LifeRingCollectionViewCell
            cell.activityData = activityData
            cell.delegate = self

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeData", for: indexPath) as! LifeDataCollectionViewCell
            cell.activityData = activityData
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
