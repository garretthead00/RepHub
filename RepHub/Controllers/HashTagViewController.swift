//
//  HashTagViewController.swift
//  RepHub
//
//  Created by Garrett Head on 7/5/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class HashTagViewController: UIViewController {

    var hashTag : String!
    private var posts = [Post]()
    private var users = [RepHubUser]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "#\(self.hashTag ?? "")"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        loadPost()
    }
    
    private func loadPost(){
        
        API.HashTag.fetchPosts(withHashTag: hashTag, completion: {
            postId in
            API.Post.observePost(withId: postId, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPost" {
            let detailVC = segue.destination as! DetailPostTableViewController
            let postId = sender as! String
            detailVC.postId = postId
        }
    }
}

extension HashTagViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PostCollectionViewCell
        let post = self.posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! LockerCRV
//        if let user = self.user {
//            headerView.user = user
//        }
//        return headerView
//    }
    
}

extension HashTagViewController : UICollectionViewDelegateFlowLayout {
    
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

extension HashTagViewController : PostCellDelegate{
    func goToDetailPostTVC(postId: String) {
        performSegue(withIdentifier: "DetailPost", sender: postId)
    }
}
