//
//  DrinkNutritionTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/20/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class DrinkNutritionTableViewController: UITableViewController {

    var drink : Drink?
    var nutrients : [Nutrient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.drink?.name
        self.loadNutritionFacts()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))

    }
    
    @objc private func addTapped(){
        NutritionStore.saveDrink(drink: self.drink!, nutrients: self.nutrients)
    }
    
    
    private func loadNutritionFacts(){
        if let drink = self.drink {
            print("drinkId: \(drink.ndb_no!)")
            
                API.Nutrient.observeNutrition(withId: String(drink.ndb_no!), completion: {
                    nutrient in
                    print("nutrient returned :\(nutrient.name)")
                    self.nutrients.append(nutrient)
                    self.tableView.reloadData()
                })

        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.nutrients.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Manufacturer", for: indexPath)
            if let dataAvailable = self.drink?.dateAvailable! {
                cell.textLabel?.text = dataAvailable
            } else {
                cell.textLabel?.text = ""
            }
            return cell
        } else {
            let nutrient = self.nutrients[indexPath.row-1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Nutrient", for: indexPath)
            if let name = nutrient.name, let value = nutrient.value, let unit = nutrient.unit {
                cell.textLabel?.text = name
                cell.detailTextLabel?.text = "\(value) \(unit)"
            } else {
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
            }
            return cell
        }
    }
 

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
