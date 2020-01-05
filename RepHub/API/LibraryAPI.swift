//
//  LibraryAPI.swift
//  RepHub
//
//  Created by Garrett Head on 1/4/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import Foundation
import FirebaseDatabase

class LibraryAPI {
    
    var LIBRARY_DB_REF = Database.database().reference().child("library")
    
    func observeFood(completion: @escaping(FoodItem) -> Void){}
    func observeFood(ofType foodType: String, completion: @escaping(FoodItem) -> Void){
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        LIBRARY_DB_REF.child(currentUserId).child(foodType.lowercased()).observe(.childAdded, with: {
            snapshot in
            if let data = snapshot.value as? [String:Any] {
                let food = FoodItem.transformFood(data: data, key: snapshot.key)
                completion(food)
            }
        })
    }
    func removeFood(){}
    func updateFood(){}
    func createFood(){}
    
    func createDrink(drink: FoodItem, completion: @escaping(Bool) -> Void) {
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        let userLibraryRef = LIBRARY_DB_REF.child(currentUserId)
        let newFoodRef = userLibraryRef.child("drinks").childByAutoId()
        newFoodRef.setValue(["name":drink.name!, "sourceDescription": drink.sourceDescription!, "servingSize": drink.servingSize!, "servingSizeUnit": drink.servingSizeUnit!, "householdServingSize":drink.householdServingSize!, "householdServingSizeUnit":drink.householdServingSizeUnit!, "foodGroup": drink.foodGroup!, "category": drink.category!], withCompletionBlock: {
            error, ref in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                completion(false)
                return
            }
            userLibraryRef.child("nutrition").child(newFoodRef.key!).setValue(true, withCompletionBlock: {
                error, ref in
                if error != nil {
                   ProgressHUD.showError(error!.localizedDescription)
                   completion(false)
                   return
               }
                ProgressHUD.showSuccess("Drink Created!")
                completion(true)
            })
        })
    }
    
}
