//
//  PostAPI.swift
//  RepHub
//
//  This API handles all database tasks associated with Posts.
//  Created by Garrett Head on 6/20/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//


import Foundation
import FirebaseDatabase

class PostAPI {
    
    var POSTS_DB_REF = Database.database().reference().child("posts")
    var SAVED_DB_REF = Database.database().reference().child("saved")
    
    // listens to all events on the posts location of the database.
    func observePosts(completion: @escaping(Post) -> Void){
        POSTS_DB_REF.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(data: data, key: snapshot.key)
                completion(post)
            }
        }
    }
    
    func observePost(withId id: String, completion: @escaping (Post) -> Void) {
        POSTS_DB_REF.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let data = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(data: data, key: snapshot.key)
                completion(post)
            }
        })
    }
    
    func observeRepCount(withPostId id: String, completion: @escaping(Int) -> Void) {
        POSTS_DB_REF.child(id).observe(.childChanged, with: {
            snapshot in
            if let count = snapshot.value as? Int {
                completion(count)
            }
        })
    }
    
    func handleReps(postId: String, onSuccess: @escaping (Post) -> Void, onError: @escaping (_ errorMessage: String?) -> Void ){
        let postRef = API.Post.POSTS_DB_REF.child(postId)
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = API.RepHubUser.CURRENT_USER?.uid {
                //let posterUId = post["uid"] as! String
                var reps: Dictionary<String, Bool>
                reps = post["reps"] as? [String : Bool] ?? [:]
                var repCount = post["repCount"] as? Int ?? 0
                if let _ = reps[uid] {
                    // Unstar the post and remove self from stars
                    //API.RepHubUser.handleTotalRepCount(userId: posterUId, withValue: -1)
                    repCount -= 1
                    reps.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    //API.RepHubUser.handleTotalRepCount(userId: posterUId, withValue: 1)
                    repCount += 1
                    reps[uid] = true
                }
                // Set value and report transaction success
                post["repCount"] = repCount as AnyObject?
                post["reps"] = reps as AnyObject?
                currentData.value = post
                return TransactionResult.success(withValue: currentData)

            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            
            if let data = snapshot?.value as? [String: Any] {
                let post = Post.transformPostPhoto(data: data, key: snapshot!.key)
                onSuccess(post)
            }
        }
    }
    
    
    func observeTopPost(completion: @escaping(Post) -> Void) {
        
        var blockedUsers = [String]()
        API.Block.fetchBlockedUsers(completion: {
            userId in
            print("blocked")
            blockedUsers.append(userId)
        })
        API.Block.fetchBlockedByUsers(completion: {
            userId in
            print("blockedby")
            blockedUsers.append(userId)

        })
        print("blockersUsers.count: \(blockedUsers.count)")
        POSTS_DB_REF.queryOrdered(byChild: "repCount").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ child in
                if let data = child.value as? [String: Any] {
                    let uid = data["uid"] as! String
                    if !blockedUsers.contains(uid) {
                        let post = Post.transformPostPhoto(data: data, key: child.key)
                        completion(post)
                    }
                }
            })
            
        })
    }
    
    func savePost(withPostId id: String, completion: @escaping(Post) -> Void){
        guard let currentuser = API.RepHubUser.CURRENT_USER else {
            return
        }
        SAVED_DB_REF.child(currentuser.uid).child(id).setValue(true, withCompletionBlock: {
            error, ref in
            self.POSTS_DB_REF.child(ref.key!).child("saved").child(currentuser.uid).setValue(true, withCompletionBlock: {
                error, ref in
                self.observePost(withId: id, completion: {
                    post in
                    print("post.isSaved: \(post.isSaved)")
                    completion(post)
                })
            })
            
        })
        
    }
    
    func removeSaved(withPostId id: String, completion: @escaping(Post) -> Void) {
        guard  let currentuser = API.RepHubUser.CURRENT_USER else {
            return
        }
        
        SAVED_DB_REF.child(currentuser.uid).child(id).removeValue(completionBlock: {
            err, ref in
            self.POSTS_DB_REF.child(ref.key!).child("saved").child(currentuser.uid).removeValue(completionBlock: {
                error, ref in
                print("post ref: \(ref)")
                self.observePost(withId: id, completion: {
                    post in
                    completion(post)
                })
                
            })
        })
    }
    
    func fetchSavedPosts(completion: @escaping(Post) -> Void){
        guard let currentuser = API.RepHubUser.CURRENT_USER else {
            return
        }
        SAVED_DB_REF.child(currentuser.uid).observe(.childAdded, with: {
            snapshot in
            let postId = snapshot.key
            self.POSTS_DB_REF.child(postId).observeSingleEvent(of: .value, with: {
                postSnapshot in
                if let data = postSnapshot.value as? [String: Any] {
                    let post = Post.transformPostPhoto(data: data, key: postSnapshot.key)
                    completion(post)
                }
            })
            
        })
        
    }
    
    func disableComments(withPostId id: String) {
        POSTS_DB_REF.child(id).child("isCommentsDisabled").setValue(true)
    }
    
    func enableComments(withPostId id: String) {
        POSTS_DB_REF.child(id).child("isCommentsDisabled").setValue(false)
    }

    
}



