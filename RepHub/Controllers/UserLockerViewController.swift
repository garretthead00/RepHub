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

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var followButton: UIButton!
    private var user: RepHubUser!
    private var userPosts : [Post] = []
    var userId = ""
    
    var delegate : UserLockerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchUserPosts()
    }
    
    private func fetchUser(){
        API.RepHubUser.observeUser(withId: userId, completion: { user in
            self.isFollowing(userId: user.uid!, completed: {
                value in
                user.isFollowing = value
                self.user = user
                self.navigationItem.title = user.username
                if user.uid != API.RepHubUser.CURRENT_USER?.uid {
                    if user.isFollowing! {
                        self.configureUnfollowButton()
                    } else {
                        self.configureFollowButton()
                    }
                } else {
                    self.followButton.isHidden = true
                }
                self.collectionView.reloadData()
            })
        })
    }
    
    private func fetchUserPosts(){
        API.UserPosts.USER_POSTS_DB_REF.child(userId).observe(.childAdded, with: {
            snapshot in
            API.Post.observePost(withId: snapshot.key, completion: {
                post in
                self.userPosts.append(post)
                self.collectionView.reloadData()
            })
        })
    }
    
    func configureFollowButton() {
        self.followButton.backgroundColor = UIColor(red: 8/255, green: 129/255, blue: 194/255, alpha: 1)
        self.followButton.frame.size.width = 70
        self.followButton.frame.size.height = 18
        self.followButton.layer.cornerRadius = 3
        self.followButton.setTitleColor(UIColor.white, for: .normal)
        self.followButton.setTitle("Follow", for: UIControl.State.normal)
        self.followButton.addTarget(self, action: #selector(self.followUser), for: UIControl.Event.touchUpInside)
    }
    
    func configureUnfollowButton() {
        self.followButton.backgroundColor = UIColor.lightGray
        self.followButton.frame.size.width = 70
        self.followButton.frame.size.height = 18
        self.followButton.layer.cornerRadius = 3
        self.followButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.followButton.setTitle("Following", for: UIControl.State.normal)
        self.followButton.addTarget(self, action: #selector(self.unfollowUser), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func followUser() {
        if !user!.isFollowing! {
            API.Follow.followAction(withUser: user!.uid!)
            configureUnfollowButton()
            user!.isFollowing! = true
            delegate?.updateFollowButton(forUser: user!)
        }
    }
    
    @objc private func unfollowUser() {
        if self.user!.isFollowing! {
            API.Follow.unFollowAction(withUser: self.user!.uid!)
            self.configureFollowButton()
            self.user!.isFollowing! = false
        }
    }
    

    private func isFollowing(userId: String, completed: @escaping(Bool) -> Void) {
        API.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPost" {
            let detailVC = segue.destination as! DetailPostTableViewController
            let postId = sender as! String
            detailVC.postId = postId
        }
    }

}

extension UserLockerViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PostCollectionViewCell
        let post = self.userPosts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! LockerCRV
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
