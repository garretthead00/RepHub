//
//  FoodMenuController.swift
//  RepHub
//
//  Created by Garrett Head on 4/2/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class FoodMenuController: UITableViewController {

    
    // MARK: Food
    var food = [FoodItem]() { didSet{ self.refreshController() } }
    var savedFood = [FoodItem]() { didSet{ self.refreshController() } }
    var displayFood = [FoodItem]()
    
    // MARK: - Filter control properties
    var isSearching = false
    var filters = [String]()
    var selectedFilter : Int?
    var searchText : String = ""
    var dataSourceFilterIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = true
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.delegate = self
        search.searchBar.text = self.searchText
        search.searchBar.sizeToFit()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.loadFood()
    }
    
    
    // MARK: API
    private func loadFood(){
        API.Food.observeFood(completion: {
            foodItem in
            self.food.append(foodItem)
        })
        API.Library.observeFood(ofType: "drinks", completion: {
            foodItem in
            self.savedFood.append(foodItem)
        })
    }
    
    @objc private func addFood(){
        print("Food created!")
        self.performSegue(withIdentifier: "CreateFood", sender: nil)
    }
    
    @objc private func updateDataSource(segment: UISegmentedControl) {
        print("updateDataSource")
        self.dataSourceFilterIndex = segment.selectedSegmentIndex
        self.selectedFilter = nil
        self.refreshController()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayFood.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "filterView", for: indexPath) as! FoodMenuFilterView
            cell.delegate = self
            cell.selectedFilter = selectedFilter
            cell.filters = filters
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemView", for: indexPath) as! FoodMenuItemView
            cell.drink = displayFood[row - 1]
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
        let segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        segmentedControl.insertSegment(withTitle: "Library", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Alpha", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = self.dataSourceFilterIndex
        segmentedControl.addTarget(self, action: #selector(updateDataSource), for: .valueChanged)
        let v = UIView()
        v.backgroundColor = .black
        v.addSubview(segmentedControl)
        return v
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row at indexpath.row: \(indexPath.row-1)")
        self.performSegue(withIdentifier: "Nutrition", sender: displayFood[indexPath.row-1])
    }


    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "Nutrition" {
             let foodController = segue.destination as! FoodItemController
             let foodItem = sender as! FoodItem
             foodController.foodItem = foodItem
         }
     }

}

extension FoodMenuController {
    
    private func refreshController(){
        displayFood.removeAll()
        filters.removeAll()
        
        displayFood = (dataSourceFilterIndex == 0) ? savedFood : food
        setFilters()
        
        // searchText filter
        if !searchText.isEmpty {
            displayFood = displayFood.filter({(foodItem : FoodItem) -> Bool in
                return (foodItem.name?.lowercased().contains(searchText.lowercased()))!
            })
        }

        // filter items
        if let filter = selectedFilter {
            displayFood = displayFood.filter({
                return $0.category == self.filters[filter]
            })
        }
        
        // sort the drinks by name
        displayFood.sort {
            $0.name! < $1.name!
        }
        self.tableView.reloadData()
    }
    
    private func setFilters(){
        for foodItem in displayFood {
            if let category = foodItem.category{
                if !self.filters.contains(category)  {
                    self.filters.append(category)
                }
            }
        }
    }
    
}

extension FoodMenuController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search did change!")
        if searchText.isEmpty {
            self.isSearching = false
            self.searchText = ""
            self.refreshController()
        } else {
            self.isSearching = true
            self.searchText = searchText
            self.refreshController()
        }
    }
}

extension FoodMenuController : FoodMenuFilterDelegate {
    func applyFilter(index: Int) {
        self.selectedFilter = index
        self.refreshController()
    }
    
    
}
