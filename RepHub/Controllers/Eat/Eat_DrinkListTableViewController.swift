//
//  Eat_DrinkListTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/6/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class Eat_DrinkListTableViewController: UITableViewController {
    
    private var drinks = [Drink]()
    private var drinksByType = [String : [Drink]]()
    var drinkType : String? {
        didSet {
            self.fetchDrinksByType()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.drinkType
    }
    
    
    private func fetchDrinksByType(){
//        API.Drink.observeDrinks(byType: self.drinkType!, completion: {
//            drink in
//            self.drinks.append(drink)
//            self.drinksByType = Dictionary(grouping: self.drinks, by: { $0.type! })
//            self.tableView.reloadData()
//        })
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.drinksByType.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(self.drinksByType)[section].key
        return self.drinksByType[key]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = Array(self.drinksByType)[indexPath.section].key
        let cell = tableView.dequeueReusableCell(withIdentifier: "Drink", for: indexPath)
        cell.textLabel?.text = self.drinksByType[key]![indexPath.row].name //self.drinks[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = Array(self.drinksByType)[section].key
        return key
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
