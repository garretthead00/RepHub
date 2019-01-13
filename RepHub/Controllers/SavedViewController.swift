//
//  SavedViewController.swift
//  RepHub
//
//  Created by Garrett Head on 1/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var posts : [Post] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        loadTopPosts()
    }
    
    
    private func loadTopPosts(){
        ProgressHUD.show("Loading...", interaction: false)
        self.posts.removeAll()
        self.collectionView.reloadData()
        API.Post.observeTopPost(completion: {
            post in
            self.posts.append(post)
            self.collectionView.reloadData()
            ProgressHUD.dismiss()
        })
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


extension SavedViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCell", for: indexPath) as! PostCollectionViewCell
        let post = self.posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
    
}

extension SavedViewController : UICollectionViewDelegateFlowLayout {
    
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

extension SavedViewController : PostCellDelegate{
    func goToDetailPostTVC(postId: String) {
        performSegue(withIdentifier: "DetailPost", sender: postId)
    }
    
}
