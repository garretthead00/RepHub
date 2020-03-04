//
//  CreateDrink_StepTwoController.swift
//  RepHub
//
//  Created by Garrett Head on 1/5/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class CreateDrink_StepTwoController: UITableViewController {

    var drinkDescription : String?
    var upload : UIImage?
    
    // properties from step one
    var name : String?
    var foodGroup: String? = "Drinks"
    var servingSize: Double?
    var servingUnit : String?
    var ingredients = [FoodItem]()
    var nutrients = [Nutrient]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func saveDrink(_ sender: Any) {
        print("save! -- name: \(self.name), foodGroup: \(self.foodGroup), servingSize: \(self.servingSize), servingUnit: \(self.servingUnit), desc: \(self.drinkDescription)")
        let foodItem = FoodItem()
        foodItem.name = self.name
        foodItem.foodGroup = self.foodGroup
        foodItem.servingSize = self.servingSize
        foodItem.servingSizeUnit = self.servingUnit
        foodItem.householdServingSize = self.servingSize
        foodItem.householdServingSizeUnit = self.servingUnit
        foodItem.sourceDescription = self.drinkDescription
        // API create food
        API.Library.createDrink(drink: foodItem, completion: {
            data in
            if data {
                print("saved data")
            } else {
                print("no saved data")
            }
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageView", for: indexPath) as! CreateDrinkImageView
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionView", for: indexPath) as! CreateDrinkDescriptionView
            cell.delegate = self
            return cell
        }
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateDrink_StepTwoController : CreateFoodDelegate {
    func updateName(name: String) {
 
    }
    
    func updateFoodGroup(foodGroup: String) {

    }
    
    
    func updateIngredients(ingredients: [FoodItem]) {

    }
    
    func updateNutrients(nutrients: [Nutrient]) {

    }
    
    func updateUploadImage(image: UIImage) {
        self.upload = image
    }
    
    func updateDescription(description: String) {
        self.drinkDescription = description
    }
    
    func updateServingSize(serving: Double) {
        
    }
    
    func updateServingUnit(unit: String) {
       
    }
    
    
}
