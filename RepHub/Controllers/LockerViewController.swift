//
//  LockerViewController.swift
//  RepHub
//
//  Created by Garrett Head on 2/10/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class LockerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var TrailingConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var lockerMenuView: LockerMenuView!
    
    var user: RepHubUser!
    var userPosts : [Post] = []
    var taggedPosts : [Post] = []
    var viewingPosts : [Post] = []
    var isMenuShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TrailingConstraint.constant = 210
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        fetchUser()
        fetchUserPosts()
        fetchTaggedPosts()
        self.lockerMenuView?.delegate = self

    }
    
    
     func fetchUser(){
        API.RepHubUser.observerCurrentUser(completion: { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
        })
    }
    
     func fetchUserPosts(){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        API.UserPosts.USER_POSTS_DB_REF.child(currentUser.uid).observe(.childAdded, with: {
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
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        API.UserTag.USERTAG_DB_REF.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            API.Post.observePost(withId: snapshot.key, completion: {
                post in
                self.taggedPosts.append(post)
                self.collectionView.reloadData()
            })
        })
    }
    @IBAction func menu_TouchUpInside(_ sender: Any) {
        if (isMenuShowing) {
            TrailingConstraint.constant = 210
        } else {
            TrailingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
        }
        isMenuShowing = !isMenuShowing

    }
    
    @IBAction func tagged_TouchUpInside(_ sender: Any) {
        self.viewingPosts = []
        self.viewingPosts = self.taggedPosts
        self.collectionView.reloadData()
    }
    
    @IBAction func posts_TouchUpInside(_ sender: Any) {
        self.viewingPosts = []
        self.viewingPosts = self.userPosts
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            let settingsVC = segue.destination as! SettingTableViewController
            settingsVC.delegate = self
        }
        if segue.identifier == "DetailPost" {
            let detailVC = segue.destination as! DetailPostTableViewController
            let postId = sender as! String
            detailVC.postId = postId
        }

    }
    
}

extension LockerViewController : UICollectionViewDataSource {
    
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
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! LockerCRV
        if let user = self.user {
         headerView.user = user
        }
        return headerView
    }
    
    
    
}


extension LockerViewController : UICollectionViewDelegateFlowLayout {
    
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

extension LockerViewController: SettingsDelegate {
    func updateLocker(){
        self.fetchUser()
    }
}

extension LockerViewController : PostCellDelegate{
    func goToDetailPostTVC(postId: String) {
        performSegue(withIdentifier: "DetailPost", sender: postId)
    }
}

extension LockerViewController : LockerMenuViewDelegate {
    func goTo(identifier: String) {
        print("dele boys")
        performSegue(withIdentifier: identifier, sender: nil)

    }
    
    
}
