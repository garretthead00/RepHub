//
//  SidePanelViewController.swift
//  RepHub
//
//  Created by Garrett on 1/7/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//
import UIKit

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
   
    
    private var menuOptions = ["Activity","Messenger","Stats","Following","Followers","Settings"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source
extension SidePanelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LockerMenuCell", for: indexPath) as! LockerMenuTableViewCell
        return cell
    }
}

// Mark: Table View Delegate
extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("menu item selecte: \(indexPath.row)")

    }
}

