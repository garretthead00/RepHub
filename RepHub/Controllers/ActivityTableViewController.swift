//
//  ActivityTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 2/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class ActivityTableViewController: UITableViewController {

    
    var items = ["caloriesBurned", "exerciseMinutes", "distance", "steps", "caloriesConsumed", "hydration", "sleep"]//,"caffeine", "sugar", "protein", "fats", "weight"]
    var colors = [UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0),UIColor(red:0.11, green:0.83, blue:1.00, alpha:1.0),UIColor(red:0.00, green:0.55, blue:0.80, alpha:1.0),UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0),UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0),UIColor(red:0.00, green:0.55, blue:0.80, alpha:1.0),UIColor(red:0.84, green:0.43, blue:0.99, alpha:1.0)]
    var values = ["487","45","3.4","2743","739","46","6.5"]
    var textColors = [UIColor(red:0.99, green:0.16, blue:0.10, alpha:1.0),UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0),UIColor(red:0.13, green:0.26, blue:0.65, alpha:1.0),UIColor(red:0.12, green:0.39, blue:0.93, alpha:1.0),UIColor(red:0.01, green:0.70, blue:0.12, alpha:1.0),UIColor(red:0.13, green:0.26, blue:0.65, alpha:1.0),UIColor(red:0.52, green:0.16, blue:0.75, alpha:1.0)]
    var icons = ["energyBurned","exerciseMinutes","distance","steps","meals","hydrate","sleep"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("----ACTIVITY TVC -----")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyViewCell", for: indexPath) as! WeeklyViewCell
             print("--WeeklyViewCell")
            cell.items = self.items
            cell.colors = self.colors
            cell.values = self.values
            cell.textColors = self.textColors
            cell.icons = self.icons
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyViewCell", for: indexPath) as! DailyViewCell
             print("--DailyViewCell")
            cell.items = self.items
            cell.colors = self.colors
            cell.values = self.values
            cell.textColors = self.textColors
            cell.icons = self.icons
            return cell
        }
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row % 2 > 0) ? calculateRowHeight(row: indexPath.row) : 248
    }
    
    private func calculateRowHeight(row : Int) -> CGFloat {
        let totalItem: CGFloat = CGFloat(self.items.count)
        let totalCellInARow: CGFloat = 2
        let cellHeight: CGFloat = 132
        
        let collViewTopOffset: CGFloat = 10
        let collViewBottomOffset: CGFloat = 10
        
        let minLineSpacing: CGFloat = 5
        
        // calculations
        let totalRow = ceil(totalItem / totalCellInARow)
        let totalTopBottomOffset = collViewTopOffset + collViewBottomOffset
        let totalSpacing = CGFloat(totalRow - 1) * minLineSpacing   // total line space in UICollectionView is (totalRow - 1)
        return (cellHeight * totalRow) + totalTopBottomOffset + totalSpacing
    }

    
}
