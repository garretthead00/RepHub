//
//  HelperService.swift
//  RepHub
//
//  Created by Garrett Head on 6/24/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

class HelperService {
    
    static func uploadToServer(data: Data, videoUrl: URL? = nil, ratio: CGFloat, caption: String, isCommentsDisabled: Bool, onSuccess: @escaping() -> Void) {
        
        if let videoUrl = videoUrl {
            self.uploadVideoToStorage(videoUrl: videoUrl, onSuccess: { videoUrl in
                self.uploadToStorage(data: data, onSuccess: { thumbnailImageUrl in
                    self.postToDatabase(photoUrl: thumbnailImageUrl, videoUrl: videoUrl, ratio: ratio, caption: caption, isCommentsDisabled: isCommentsDisabled, onSuccess: onSuccess)
                })
            })
        } else {
            self.uploadToStorage(data: data) {
                photoUrl in
                self.postToDatabase(photoUrl: photoUrl, ratio: ratio, caption: caption, isCommentsDisabled: isCommentsDisabled, onSuccess: onSuccess)
            }
        }
    }
    
    static func uploadVideoToStorage(videoUrl: URL, onSuccess: @escaping(_ videoUrl: String) -> Void) {
        let videoId = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(videoId)
        storageRef.putFile(from: videoUrl, metadata: nil, completion: {
            (metadata, error) in
            if error != nil {
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    return
                }
                let videoUrl = url?.absoluteString
                onSuccess(videoUrl!)
            })
        })
    }
    
    static func uploadToStorage(data: Data, onSuccess: @escaping(_ imageUrl: String) -> Void){
        let photoId = NSUUID().uuidString
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoId)
        
        
        storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    return
                }
                let photoUrl = url?.absoluteString
                onSuccess(photoUrl!)
            })
        })
    }
    
    static private func postToDatabase(photoUrl : String, videoUrl: String? = nil, ratio: CGFloat, caption: String, isCommentsDisabled: Bool, onSuccess: @escaping() -> Void) {

        let newPostId = API.Post.POSTS_DB_REF.childByAutoId().key
        let newPostReference = API.Post.POSTS_DB_REF.child(newPostId!)
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        
        let words = caption.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                let newHashTagRef = API.HashTag.HASHTAG_DB_REF.child(word.lowercased())
                newHashTagRef.updateChildValues([newPostId:true])
            }
            if word.hasPrefix("@") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                API.RepHubUser.observeUserByName(username: word, completion: {
                    user in
                    let newUserTagRef = API.UserTag.USERTAG_DB_REF.child(user.uid!)
                    newUserTagRef.updateChildValues([newPostId:true])
                })

            }
        }
        let timestamp = Int(Date().timeIntervalSince1970)
        var data = ["uid": currentUserId,"photoUrl": photoUrl, "caption": caption, "repCount": 0, "ratio": ratio, "timestamp": timestamp, "isCommentsDisabled" : isCommentsDisabled] as [String : Any]
        if let videoUrl = videoUrl {
            data["videoUrl"] = videoUrl
        }
        
        newPostReference.setValue(data,  withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            API.Feed.FEED_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).child(newPostId!).setValue(["timestamp": timestamp])
            API.Follow.FOLLOWERS_DB_REF.child(API.RepHubUser.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
                snapshot in
                let snapshotArr = snapshot.children.allObjects as! [DataSnapshot]
                snapshotArr.forEach({ child in
                    API.Feed.FEED_DB_REF.child(child.key).child(newPostId!).setValue(["timestamp": timestamp])
                    let newNotificationId = API.Notification.NOTIFICATION_DB_REF.child(child.key).childByAutoId().key
                    let newNotificationReference = API.Notification.NOTIFICATION_DB_REF.child(child.key).child(newNotificationId!)
                    newNotificationReference.setValue(["from": API.RepHubUser.CURRENT_USER!.uid, "type": "feed", "objectId":newPostId, "timestamp": timestamp])
                })
            })
            let userpostRef = API.UserPosts.USER_POSTS_DB_REF.child(currentUserId).child(newPostId!)
            userpostRef.setValue(["timestamp": timestamp], withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            ProgressHUD.showSuccess("Successfull")
            onSuccess()
        })
    }
    
}
