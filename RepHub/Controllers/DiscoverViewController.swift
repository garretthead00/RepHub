//
//  DiscoverUserViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

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
    
    func searchUsers(){
        if let searchText = searchBar.text?.lowercased(){
            self.users.removeAll()
            self.tableView.reloadData()
            API.RepHubUser.queryUsers(withText: searchText, completion: { user in
                self.isFollowing(userId: user.uid!, completed: {
                    value in
                    user.isFollowing = value
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

extension DiscoverViewController : UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverUserTableViewCell", for: indexPath) as! DiscoverUserTableViewCell
        cell.user = self.users[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension DiscoverViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUsers()
    }
}

extension DiscoverViewController: DiscoverUserCellDelegate {
    func gotoUserLockerVC(userId: String?) {
        performSegue(withIdentifier: "ViewLocker", sender: userId)
    }
    
}

extension DiscoverViewController: UserLockerDelegate {
    func updateFollowButton(forUser user: RepHubUser) {
        for u in self.users {
            if u.uid == user.uid {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
}
