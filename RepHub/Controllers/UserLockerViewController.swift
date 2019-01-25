//
//  UserLockerViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/29/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

protocol UserLockerDelegate {
    func updateFollowButton(forUser user: RepHubUser)
}

class UserLockerViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private var user: RepHubUser!
    private var userPosts : [Post] = []
    var taggedPosts : [Post] = []
    var viewingPosts : [Post] = []
    var userId = ""
    var delegate : UserLockerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchUserPosts()
        fetchTaggedPosts()
    }
    
    private func fetchUser(){
        API.RepHubUser.observeUser(withId: userId, completion: {
            user in
            self.user = user
            self.isFollowing(userId: user.uid!, completed: {
                value in
                user.isFollowing = value
                self.isBlocked(userId: user.uid!, completed: {
                    value in
                    user.isBlocked = value
                    self.navigationItem.title = user.username
                    self.collectionView.reloadData()
                })
            })

        })
    }
    
    private func fetchUserPosts(){
        API.UserPosts.USER_POSTS_DB_REF.child(userId).observe(.childAdded, with: {
            snapshot in
            API.Post.observePost(withId: snapshot.key, completion: {
                post in
                self.userPosts.append(post)
                self.viewingPosts.append(post)
                self.collectionView.reloadData()
            })
        })
    }
    
    func fetchTaggedPosts(){
        API.UserTag.USERTAG_DB_REF.child(userId).observe(.childAdded, with: {
            snapshot in
            API.Post.observePost(withId: snapshot.key, completion: {
                post in
                self.taggedPosts.append(post)
                self.collectionView.reloadData()
            })
        })
    }

    private func isFollowing(userId: String, completed: @escaping(Bool) -> Void) {
        API.Follow.isFollowing(userId: userId, completed: completed)
    }
    private func isBlocked(userId: String, completed: @escaping(Bool) -> Void) {
        API.Block.isBlocked(userId: userId, completion: completed)
    }
    
    @IBAction func posts_TouchUpInside(_ sender: Any) {
        print("show user posts")
        self.viewingPosts = []
        self.viewingPosts = self.userPosts
        self.collectionView.reloadData()
    }
    
    @IBAction func tagged_TouchUpInside(_ sender: Any) {
        print("show tagged posts")
        self.viewingPosts = []
        self.viewingPosts = self.taggedPosts
        self.collectionView.reloadData()
    }
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPost" {
            let detailVC = segue.destination as! DetailPostTableViewController
            let postId = sender as! String
            detailVC.postId = postId
        }
    }

    @IBAction func menuButton_TouchUpInside(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Report", style: .default, handler: { action in
            API.Report.reportUser(withId: self.user!.uid!, comment: "comment")
        })
        
        if self.user.isBlocked! {
            let unblockAction = UIAlertAction(title: "Unblock", style: .default, handler: { action in
                API.Block.unblockUser(withId: self.user!.uid!)
            })
            unblockAction.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(unblockAction)
        } else {
            let blockAction = UIAlertAction(title: "Block", style: .default, handler: { action in
                API.Block.blockUser(withId: self.user!.uid!)
            })
            blockAction.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(blockAction)
        }
        
        if self.user.isFollowing! {
            let muteAction = UIAlertAction(title: "Mute", style: .default, handler: { action in
                API.Mute.muteUser(withId: self.user!.uid!)
            })
            muteAction.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(muteAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        })
        
        reportAction.setValue(UIColor.red, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.darkGray, forKey: "titleTextColor")
        alert.addAction(reportAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension UserLockerViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewingPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PostCollectionViewCell
        let post = self.viewingPosts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! UserLockerCRV
        if let user = self.user {
            headerView.user = user
        }
        return headerView
    }
    
}

extension UserLockerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 3 - 1, height: self.collectionView.frame.size.width / 3 - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
}

extension UserLockerViewController : PostCellDelegate{
    func goToDetailPostTVC(postId: String) {
        performSegue(withIdentifier: "DetailPost", sender: postId)
    }
    
}
