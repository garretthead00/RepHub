//
//  AuthService.swift
//  RepHub
//
//  Created by Garrett Head on 6/13/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthService {
    
    // static var shared = AuthService()
    // static var storageRef = StorageRoot() // "gs://rephub-app.appspot.com"
    static func loginUser(email : String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage : String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            //onSuccess allow to call after the signin method is returned
            onSuccess()
        })
    }
    
    static func registerUser(username: String, email : String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage : String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let uid = user?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid!)

                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil{
                            return
                        }
                        let profileImageUrl = url?.absoluteString
                        self.setUserData(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)

                    })
                })
        })
    }
    
    static private func setUserData(profileImageUrl: String, username : String, email: String, uid: String, onSuccess: @escaping () -> Void){
        let databaseRef = Database.database().reference()
        let usersReference = databaseRef.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImage": profileImageUrl, "totalRepCount": 0])
        print("user created. signing in...")
        onSuccess()
    }
    
    static func updateUserInfo(username: String, email : String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage : String?) -> Void){
        
        API.RepHubUser.CURRENT_USER?.updateEmail(to: email, completion: { error in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                let uid = API.RepHubUser.CURRENT_USER?.uid
                let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid!)
                
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil{
                            return
                        }
                        let profileImageUrl = url?.absoluteString
                        self.updateUser(profileImageUrl: profileImageUrl!, username: username, email: email, onSuccess: onSuccess, onError: onError)
                        
                        
                    })
                })
            }
        })
        
    }
        
    static func updateUser(profileImageUrl: String, username : String, email: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage : String?) -> Void){
        let data = ["username": username, "username_lowercase": username.lowercased(), "email": email, "profileImage": profileImageUrl]
        API.RepHubUser.CURRENT_USER_REF?.updateChildValues(data, withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                onSuccess()
            }
            
        })
    
    }
    
    static func logout(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage : String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
        

    }
    
}
