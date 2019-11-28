//
//  DrinkMenuCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import HealthKit

private let reuseIdentifier = "DrinkCell"

class DrinkMenuCollectionViewController: UICollectionViewController {
    
    
    var drinks : [String] = ["Water", "Coffee", "Tea", "Milk", "Juice", "Shake", "Energy", "Sports Drink", "Soda", "Beer", "Wine", "Cocktail"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Drinks" {
            let drinksTVC = segue.destination as! DrinksTableViewController
            let drinkType = sender as! String
            drinksTVC.drinkType = drinkType
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.drinks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DrinkCollectionViewCell
        cell.delegate = self
        cell.drink = self.drinks[indexPath.row]
        return cell
    }



}

extension DrinkMenuCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  32
        let collectionViewSize = self.collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension DrinkMenuCollectionViewController : DrinkDelegate {
    func selectedDrink(drink: String) {
        self.performSegue(withIdentifier: "Drinks", sender: drink)
    }
}

