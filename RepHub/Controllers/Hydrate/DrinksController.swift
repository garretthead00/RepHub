//
//  DrinksController.swift
//  RepHub
//
//  Created by Garrett Head on 1/1/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class DrinksController: UITableViewController {
    
    
    var drinks = [FoodItem]() {
        didSet {
            self.refreshController()
        }
    }
    var filters = [String]() {
        didSet {
            self.refreshController()
        }
    }
    var selectedFilter : String?
    var searchText : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.loadDrinks()
    }

    
    private func refreshController(){
        self.tableView.reloadData()
    }
    
    private func loadDrinks(){
        API.Food.observeFood(ofGroup: "Drinks", completion: {
            drink in
            self.drinks.append(drink)
            if let category = drink.category, !self.filters.contains(category) {
                self.filters.append(category)
            }
        })
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drinks.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "filterView", for: indexPath) as! DrinkFiltersTableViewCell
            cell.filters = self.filters
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemView", for: indexPath) as! DrinkItemTableViewCell
            cell.drink = self.drinks[row - 1]
            return cell
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        return (row == 0) ? 64 : 128
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         
        
        let v = UIView()
         v.backgroundColor = .black
         let segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
         segmentedControl.insertSegment(withTitle: "Your Library", at: 0, animated: false)
         segmentedControl.insertSegment(withTitle: "Alpha", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
         v.addSubview(segmentedControl)
         return v
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DrinksController : DrinkSearchDelegate {
    func updateSearchText(text: String) {
        self.searchText = text
        // filter drinks
        self.refreshController()
    }
    
    
}

extension DrinksController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("updating search controller!!")
    }
    
    
}
