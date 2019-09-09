//
//  FoodGroupCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/28/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit



class FoodGroupCollectionViewController: UICollectionViewController {

    
    private var foodGroups : [String] = ["Protein", "Veg", "Fruit", "Dairy", "Grains", "Fats", "Sweets"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Food Groups"
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
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.foodGroups.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodGroup", for: indexPath) as! FoodGroupCollectionViewCell
        cell.group = self.foodGroups[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "FoodMenu", sender: self.foodGroups[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodMenu" {
            let foodMenuTVC = segue.destination as! FoodListTableViewController
            let foodGroup = sender as! String
            foodMenuTVC.foodGroup = foodGroup
        }
    }



}

extension FoodGroupCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.size.width / 2) - 14, height: 128.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    
}
