//
//  EatMealsTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class EatMealsTableViewCell: UITableViewCell {

    @IBOutlet weak var mealsCollectionView: UICollectionView!
    
    private var meals = ["Breakfast", "Lunch", "Dinner", "Snack"]
    var testCals = [520,608,712,232]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mealsCollectionView.delegate = self
        self.mealsCollectionView.dataSource = self
        self.mealsCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension EatMealsTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Meal", for: indexPath) as! MealCollectionViewCell
        cell.meal = self.meals[indexPath.row]
        cell.calorieLabel.text = "\(self.testCals[indexPath.row]) cals"
        return cell

    }
    
    
}

extension EatMealsTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 112.0, height: 138.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    
}
