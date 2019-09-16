//
//  FeedAPI.swift
//  RepHub
//
//  Created by Garrett Head on 6/26/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedAPI {
    var FEED_DB_REF  = Database.database().reference().child("feed")
    
    func getRecentFeed(withId id: String, start timestamp: Int? = nil, limit: UInt, completion: @escaping([(Post, RepHubUser)]) -> Void){
        var query = FEED_DB_REF.child(id).queryOrdered(byChild: "timestamp")
        
        if let latestPostTimeStamp = timestamp, latestPostTimeStamp > 0 {
            query = query.queryStarting(atValue: latestPostTimeStamp + 1, childKey: "timestamp").queryLimited(toLast: limit)
        } else {
            query = query.queryLimited(toLast: limit)
        }
        var results : [(post: Post, user: RepHubUser)] = []
        query.observeSingleEvent(of: .value, with: {
            snapshot in
            let items = snapshot.children.allObjects as! [DataSnapshot]
            let myGroup = DispatchGroup()
            for (_, item) in items.enumerated() {
                myGroup.enter()
                API.Post.observePost(withId: item.key, completion: {
                    post in
                    API.RepHubUser.observeUser(withId: post.uid!, completion: {
                        user in
                        API.Mute.isMuted(userId: user.uid!, completion: {
                            isMuted in
                            if !isMuted {
                                results.append((post, user))
                            }
                            myGroup.leave()
                        })
                        
                    })
                })
            }
            myGroup.notify(queue: .main, execute: {
                results.sort(by: { $0.0.timestamp! > $1.0.timestamp! })
                completion(results)
            })
        })
    }
    
    func getOldFeed(withId id: String, start timestamp: Int, limit: UInt, completion: @escaping([(Post, RepHubUser)]) -> Void) {
        let orderQuery = FEED_DB_REF.child(id).queryOrdered(byChild: "timestamp")
        let limitedQuery = orderQuery.queryEnding(atValue: timestamp - 1, childKey: "timestamp").queryLimited(toLast: limit)
        limitedQuery.observeSingleEvent(of: .value, with: {
            snapshot in
            let items = snapshot.children.allObjects as! [DataSnapshot]
            let myGroup = DispatchGroup()
            var results : [(post: Post, user: RepHubUser)] = []
            for (_, item) in items.enumerated() {
                myGroup.enter()
                API.Post.observePost(withId: item.key, completion: {
                    post in
                    API.RepHubUser.observeUser(withId: post.uid!, completion: {
                        user in
                        API.Mute.isMuted(userId: user.uid!, completion: {
                            isMuted in
                            if !isMuted {
                                results.append((post, user))
                            }
                            myGroup.leave()
                        })
                    })
                })
            }
            myGroup.notify(queue: .main, execute: {
                results.sort(by: { $0.0.timestamp! > $1.0.timestamp! })
                completion(results)
            })
        })
    }
    
    func observeFeedRemoved(withId id: String, completion: @escaping(String) -> Void) {
        FEED_DB_REF.child(id).observe(.childRemoved, with: {
            snapshot in
            let key = snapshot.key
            completion(key)
        })
    }
    
}
