//
//  DrinksController.swift
//  RepHub
//
//  Created by Garrett Head on 1/1/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class DrinkMenuController: UITableViewController {
    
    // MARK: - Drinks
    var drinks = [FoodItem]() { didSet{ self.refreshController() } }
    var userDrinks = [FoodItem]() { didSet{ self.refreshController() } }
    var displayDrinks = [FoodItem]()
    
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDrink))
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.loadDrinks()
    }

    
    private func refreshController(){
        self.displayDrinks.removeAll()
        self.filters.removeAll()
        
        self.displayDrinks = (self.dataSourceFilterIndex == 0) ? self.userDrinks : self.drinks
        setFilters()
        
        // searchText filter
        if !self.searchText.isEmpty {
            self.displayDrinks = self.displayDrinks.filter({(drink : FoodItem) -> Bool in
                return (drink.name?.lowercased().contains(self.searchText.lowercased()))!
            })
        }

        // filter items
        if let filter = self.selectedFilter {
            self.displayDrinks = self.displayDrinks.filter({
                return $0.category == self.filters[filter]
            })
        }
        
        // sort the drinks by name
        self.displayDrinks.sort {
            $0.name! < $1.name!
        }
        self.tableView.reloadData()
    }
    
    private func setFilters(){
        for drink in self.displayDrinks {
            if let category = drink.category{
                if !self.filters.contains(category)  {
                    self.filters.append(category)
                }
            }
        }
    }
    
    private func loadDrinks(){
        API.Food.observeFood(ofGroup: "Drinks", completion: {
            drink in
            self.drinks.append(drink)
        })
        API.Library.observeFood(ofType: "drinks", completion: {
            drink in
            self.userDrinks.append(drink)
        })
    }
    
    // add drink
    @objc private func addDrink(){
        //API.Library.createFood()
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
        return self.displayDrinks.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "filterView", for: indexPath) as! DrinkFiltersTableViewCell
            cell.delegate = self
            cell.selectedFilter = self.selectedFilter
            cell.filters = self.filters
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemView", for: indexPath) as! DrinkView
            cell.drink = self.displayDrinks[row - 1]
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
        self.performSegue(withIdentifier: "Nutrition", sender: self.displayDrinks[indexPath.row-1])
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Nutrition" {
            let drinkTVC = segue.destination as! DrinkController
            let drink = sender as! FoodItem
            drinkTVC.drink = drink
        }
    }

}

extension DrinkMenuController : UISearchBarDelegate {
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

extension DrinkMenuController : DrinkMenuFilterDelegate {
    func applyFilter(index: Int) {
        self.selectedFilter = index
        self.refreshController()
    }
    
    
}
