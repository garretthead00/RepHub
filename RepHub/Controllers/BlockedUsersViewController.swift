//
//  BlockedUsersViewController.swift
//  RepHub
//
//  Created by Garrett on 1/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class BlockedUsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var users : [RepHubUser] = []
    private var searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure Searchbar
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.placeholder = "Search"
        self.searchBar.frame.size.width = view.frame.size.width - 60
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        self.loadUsers()
    }
    
    private func loadUsers() {
        
        API.RepHubUser.observeUsers(completion: {
            user in
            self.isFollowing(userId: user.uid!, completed: {
                value in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })
        })
    }
    
    private func isFollowing(userId: String, completed: @escaping(Bool) -> Void) {
        API.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    private func isBlocked(userId: String, completed: @escaping(Bool) -> Void) {
        API.Block.isBlocked(userId: userId, completion: completed)
    }
    
    func searchUsers(){
        if let searchText = searchBar.text?.lowercased(){
            self.users.removeAll()
            self.tableView.reloadData()
            API.RepHubUser.queryUsers(withText: searchText, completion: { user in
                self.isBlocked(userId: user.uid!, completed: {
                    isBlocked in
                    user.isBlocked = isBlocked
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewLocker" {
            let userVC = segue.destination as! UserLockerViewController
            let userId = sender as! String
            userVC.userId = userId
            userVC.delegate = self
        }
    }
    
}

extension BlockedUsersViewController : UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedUserTableViewCell", for: indexPath) as! BlockedUserTableViewCell
        cell.user = self.users[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension BlockedUsersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUsers()
    }
}

extension BlockedUsersViewController: BlockedUserCellDelegate {
    func gotoUserLockerVC(userId: String?) {
        performSegue(withIdentifier: "ViewLocker", sender: userId)
    }
    
}



