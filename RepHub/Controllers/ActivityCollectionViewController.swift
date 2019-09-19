//
//  ActivityCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ActivityCollectionViewController: UICollectionViewController {

    var mindData : LifeData?
    var exerciseData : LifeData?
    var eatData : LifeData?
    var waterData : LifeData?
    
    var lifeData : [LifeData]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        print("ActivityCtrl ViewDidLoad")
        super.viewDidLoad()
        self.loadLifeData()
    }
    
    private func loadLifeData(){
        
        self.mindData = LifeData(value: lifeValues[3], target: lifeTargets[3], color: lifeColors[3], data: LifeTypes.mind, icon: UIImage(named:lifeLabels[3])!, label: LifeTypes.mind.rawValue)
        self.exerciseData = LifeData(value: lifeValues[0], target: lifeTargets[0], color: lifeColors[0], data: LifeTypes.exercise, icon: UIImage(named:lifeLabels[0])!, label: LifeTypes.exercise.rawValue)
        self.eatData = LifeData(value: lifeValues[2], target: lifeTargets[2], color: lifeColors[2], data: LifeTypes.eat, icon: UIImage(named:lifeLabels[2])!, label: LifeTypes.eat.rawValue)
        self.waterData = LifeData(value: lifeValues[1], target: lifeTargets[1], color: lifeColors[1], data: LifeTypes.water, icon: UIImage(named:lifeLabels[1])!, label: LifeTypes.water.rawValue)
        
        self.lifeData = [self.mindData!,self.exerciseData!, self.eatData!, self.waterData!]
        
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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeRing", for: indexPath) as! LifeRingCollectionViewCell
            cell.lifeData = self.lifeData![indexPath.row]
            cell.delegate = self

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeData", for: indexPath) as! LifeDataCollectionViewCell
            cell.lifeData = self.lifeData![indexPath.row]

            return cell
        }
        
    }
    


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
