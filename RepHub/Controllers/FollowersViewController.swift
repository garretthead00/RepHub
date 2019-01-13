//
//  FollowViewController.swift
//  RepHub
//
//  Created by Garrett Head on 1/11/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
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
        
        // Load users Followers
        self.loadFollowers()
    }
    
    
    private func loadFollowers(){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        API.Follow.fetchFollowers(forUserId: currentUser.uid, completion: {
            user in
            self.isFollowing(userId: user.uid!, completed: {
                value in
                user.isFollowing = value
                self.users.append(user)
                self.tableview.reloadData()
            })
        })
    }
    
    private func isFollowing(userId: String, completed: @escaping(Bool) -> Void) {
        API.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    func searchUsers(){
        if let searchText = searchBar.text?.lowercased(){
            self.users.removeAll()
            self.tableview.reloadData()
            API.RepHubUser.queryUsers(withText: searchText, completion: { user in
                self.isFollowing(userId: user.uid!, completed: {
                    value in
                    user.isFollowing = value
                    self.users.append(user)
                    self.tableview.reloadData()
                })
            })
        }
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewLocker" {
            let userVC = segue.destination as! UserLockerViewController
            let userId = sender as! String
            userVC.userId = userId
            userVC.delegate = self
        }
    }
    

}

extension FollowersViewController : UITableViewDataSource {
    
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

extension FollowersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUsers()
    }
}

extension FollowersViewController: DiscoverUserCellDelegate {
    func gotoUserLockerVC(userId: String?) {
        performSegue(withIdentifier: "ViewLocker", sender: userId)
    }

}

extension FollowersViewController: UserLockerDelegate {
    func updateFollowButton(forUser user: RepHubUser) {
        for u in self.users {
            if u.uid == user.uid {
                u.isFollowing = user.isFollowing
                self.tableview.reloadData()
            }
        }
    }
}

