//
//  FeedTVC.swift
//  RepHub
//
//  Created by Garrett Head on 6/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit
import SDWebImage

class FeedTVC: UITableViewController {
    
    private var posts = [Post]()
    private var users = [RepHubUser]()
    fileprivate var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 420
        self.tableView.rowHeight = UITableView.automaticDimension
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.refreshControl = self.refreshControl
        self.loadPosts()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func loadPosts() {
        isLoading = true
        API.Feed.getRecentFeed(withId: API.RepHubUser.CURRENT_USER!.uid, start: posts.first?.timestamp, limit: 15) {
            results in
            if results.count > 0 {
                results.forEach({ result in
                    self.posts.append(result.0)
                    self.users.append(result.1)
                })
            }
            if (self.refreshControl?.isRefreshing)! {
                self.refreshControl?.endRefreshing()
            }
            self.isLoading = false
            self.tableView.reloadData()
        }
    }

    func loadMorePosts(){
        guard !isLoading else {
            return
        }
        isLoading = true
        guard let latestPostTimestamp = self.posts.last?.timestamp else {
            isLoading = false
            return
        }
        API.Feed.getOldFeed(withId: API.RepHubUser.CURRENT_USER!.uid, start: latestPostTimestamp, limit: 15){
            results in
            if results.count == 0 {
                return
            }
            for result in results {
                self.posts.append(result.0)
                self.users.append(result.1)
            }
            self.isLoading = false
            self.tableView.reloadData()
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + self.view.frame.size.height >= scrollView.contentSize.height {
            loadMorePosts()
        }
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
    
    @objc func refresh() {
        self.posts.removeAll()
        self.users.removeAll()
        loadPosts()
    }

}



extension FeedTVC : FeedCellDelegate {
    
    func goToCommentsVC(postId: String) {
        performSegue(withIdentifier: "Comments", sender: postId)
    }
    
    func goToUserLockerVC(userId: String) {
        performSegue(withIdentifier: "ViewLocker", sender: userId)
    }
    func goToHashTagVC(hashtag: String) {
        performSegue(withIdentifier: "HashTag", sender: hashtag)
    }
    
    func toggleMenu(postId: String,userId: String){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Report", style: .default, handler: { action in
            API.Report.reportPost(withId: postId, userId: userId, comment: "comment")
        })

        let muteAction = UIAlertAction(title: "Mute", style: .default, handler: { action in
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        })
        
        reportAction.setValue(UIColor.red, forKey: "titleTextColor")
        muteAction.setValue(UIColor.red, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.darkGray, forKey: "titleTextColor")
        alert.addAction(reportAction)
        alert.addAction(muteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

