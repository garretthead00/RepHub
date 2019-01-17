//
//  ReportAPI.swift
//  RepHub
//
//  Created by Garrett on 1/15/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ReportAPI {
    
    var USER_REPORTS_DB_REF = Database.database().reference().child("user-reports")
    var REPORTED_USERS_DB_REF = Database.database().reference().child("reportedUsers")
    var REPORTED_POSTS_DB_REF = Database.database().reference().child("reportedPosts")
    var REPORTED_COMMENTS_DB_REF = Database.database().reference().child("reportedComments")
    
    func reportUser(withId id: String, comment: String){
        if let currentUser = API.RepHubUser.CURRENT_USER {
            let newReportRef = REPORTED_USERS_DB_REF.childByAutoId()
            let timestamp = Int(Date().timeIntervalSince1970)
            newReportRef.setValue(["comment": comment, "timestamp": timestamp, "reportedByUserId": currentUser.uid, "reportedUserId": id])
            USER_REPORTS_DB_REF.child(id).setValue(["dateLastReported": timestamp])
            USER_REPORTS_DB_REF.child(id).child("reports").child(newReportRef.key).setValue(true)
        }
        
    }
    func reportPost(withId id: String, userId: String, comment: String){
        if let currentUser = API.RepHubUser.CURRENT_USER {
            let newReportRef = REPORTED_POSTS_DB_REF.childByAutoId()
            let timestamp = Int(Date().timeIntervalSince1970)
            newReportRef.setValue(["comment": comment, "timestamp": timestamp, "reportedByUserId": currentUser.uid, "reportedUserId": id, "postId": id])
            USER_REPORTS_DB_REF.child(id).setValue(["dateLastReported": timestamp])
            USER_REPORTS_DB_REF.child(id).child("post-reports").child(newReportRef.key).setValue(true)
        }
    }
    func reportComment(withId id: String, userId: String, comment: String){
        if let currentUser = API.RepHubUser.CURRENT_USER {
            let newReportRef = REPORTED_COMMENTS_DB_REF.childByAutoId()
            let timestamp = Int(Date().timeIntervalSince1970)
            newReportRef.setValue(["comment": comment, "timestamp": timestamp, "reportedByUserId": currentUser.uid, "reportedUserId": id, "commentId": id])
            USER_REPORTS_DB_REF.child(id).setValue(["dateLastReported": timestamp])
            USER_REPORTS_DB_REF.child(id).child("comment-reports").child(newReportRef.key).setValue(true)
        }
    }
    
}
