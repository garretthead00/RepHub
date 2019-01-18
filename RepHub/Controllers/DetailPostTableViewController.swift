//
//  DetailPostTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 7/2/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class DetailPostTableViewController: UITableViewController {

    var postId : String?
    private var posts = [Post]()
    private var users = [RepHubUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
    }

    private func loadPost(){
        API.Post.observePost(withId: postId!, completion: {
            post in
            guard let postUserId = post.uid else {
                return
            }
            self.fetchUser(uid: postUserId, completed: {
                self.posts.append(post)
                self.tableView.reloadData()
            })
        })
    }
    
    private func fetchUser(uid : String, completed: @escaping() -> Void ){
        API.RepHubUser.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Comments" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        if segue.identifier == "ViewLocker" {
            let userLockerVC = segue.destination as! UserLockerViewController
            let userId = sender as! String
            userLockerVC.userId = userId
        }
        if segue.identifier == "HashTag" {
            let hashTagVC = segue.destination as! HashTagViewController
            let hashTag = sender as! String
            hashTagVC.hashTag = hashTag
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! FeedTableViewCell
        let post = self.posts[indexPath.row]
        let user = self.users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
    
}

extension DetailPostTableViewController : FeedCellDelegate {
    func toggleMenu(postId: String, userId: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Report", style: .default, handler: { action in
            API.Report.reportPost(withId: postId, userId: userId, comment: "comment")
        })
        let blockAction = UIAlertAction(title: "Block", style: .default, handler: { action in
            API.Block.blockUser(withId: userId)
        })
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: { action in
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        })
        
        reportAction.setValue(UIColor.red, forKey: "titleTextColor")
        blockAction.setValue(UIColor.red, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.darkGray, forKey: "titleTextColor")
        alert.addAction(reportAction)
        alert.addAction(blockAction)
        alert.addAction(shareAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    
    
    func goToCommentsVC(postId: String) {
        performSegue(withIdentifier: "Comments", sender: postId)
    }
    
    func goToUserLockerVC(userId: String) {
        performSegue(withIdentifier: "ViewLocker", sender: userId)
    }
    
    func goToHashTagVC(hashtag: String) {
        performSegue(withIdentifier: "HashTag", sender: hashtag)
    }
    
}
