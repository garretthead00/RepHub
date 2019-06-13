//
//  ActivityTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 7/7/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class NotificationsTableViewController: UITableViewController {

    private var notifications = [Notification]()
    private var users = [RepHubUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotifications()
    }
    
    private func loadNotifications(){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        API.Notification.observeNotification(withId: currentUser.uid, completion: {
            notification in
            guard let uid = notification.from else {
                return
            }
            self.fetchUser(uid: uid, completed: {
                self.notifications.insert(notification, at: 0)
                self.tableView.reloadData()
            })
        })
    }
    
    private func fetchUser(uid : String, completed: @escaping() -> Void ){
        API.RepHubUser.observeUser(withId: uid, completion: {
            user in
            self.users.insert(user, at: 0)
            completed()
        })
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.notifications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Activity", for: indexPath) as! ActivityTableViewCell
        let user = self.users[indexPath.row]
        let notification = self.notifications[indexPath.row]
        cell.user = user
        cell.notification = notification
        cell.delegate = self
        return cell
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPost" {
            let detailVC = segue.destination as! DetailPostTableViewController
            let postId = sender as! String
            detailVC.postId = postId
        }
        if segue.identifier == "ViewLocker" {
            let profileVC = segue.destination as! UserLockerViewController
            let userId = sender  as! String
            profileVC.userId = userId
        }
        if segue.identifier == "Comments" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender  as! String
            commentVC.postId = postId
        }
    }

}

extension NotificationsTableViewController : ActivityCellDelegate{
    func goToDetailPostTVC(postId: String) {
        performSegue(withIdentifier: "DetailPost", sender: postId)
    }
    
    func goToUserLockerVC(userId: String) {
        performSegue(withIdentifier: "ViewLocker", sender: userId)
    }
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "Comments", sender: postId)
    }
    
}
