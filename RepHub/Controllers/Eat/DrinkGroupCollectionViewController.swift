//
//  DrinkGroupCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class DrinkGroupCollectionViewController: UICollectionViewController {

    private var drinkGroups : [String] = ["Water", "Coffee", "Tea", "Milk", "Juice", "Shake", "Sports Drink", "Soda", "Beer", "Wine"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Drinks"
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
        return self.drinkGroups.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinkGroup", for: indexPath) as! DrinkGroupCollectionViewCell
        cell.group = self.drinkGroups[indexPath.row]
        return cell
    }


}

extension DrinkGroupCollectionViewController : UICollectionViewDelegateFlowLayout {
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
