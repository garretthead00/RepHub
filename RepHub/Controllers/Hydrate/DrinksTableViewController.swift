//
//  DrinksTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class DrinksTableViewController: UITableViewController {

    
    var drinkType : String?
    var drinks : [Drink] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDrinks()
    }

    private func loadDrinks(){
//        if let type = self.drinkType {
//            API.Drink.observerDrinks(drinkType: type, completion: {
//                drink in
//                self.drinks.append(drink)
//                self.tableView.reloadData()
//            })
//        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.drinks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Drink", for: indexPath)
        cell.textLabel?.text = self.drinks[indexPath.row].name
        cell.detailTextLabel?.text = self.drinks[indexPath.row].dateAvailable
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row at indexpath.row: \(indexPath.row)")
        print("drink selected: \(self.drinks[indexPath.row].name)")
        self.performSegue(withIdentifier: "Nutrition", sender: self.drinks[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("accessory button tapped for row at: \(indexPath.row)")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Nutrition" {
            let nutritionTVC = segue.destination as! DrinkTableViewController
            let drink = sender as! Drink
            print("sender: \(drink.name)  \(drink.ndb_no)")
            nutritionTVC.drink = drink
        }
    }
 

}
