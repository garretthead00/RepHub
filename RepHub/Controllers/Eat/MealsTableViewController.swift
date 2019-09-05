//
//  MealsTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class MealsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.navigationItem.title = "Meals"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Meal", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
        
    }


}
