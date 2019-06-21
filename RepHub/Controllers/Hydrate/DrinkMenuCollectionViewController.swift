//
//  DrinkMenuCollectionViewController.swift
//  RepHub
//
//  Created by Garrett Head on 6/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import HealthKit

private let reuseIdentifier = "DrinkCell"

class DrinkMenuCollectionViewController: UICollectionViewController {
    
    
    var drinks : [String] = ["Water", "Coffee", "Milk", "Shake", "Sports Drink", "Juice", "Tea", "Beer", "Wine", "Soda"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Drinks" {
            let drinksTVC = segue.destination as! DrinksTableViewController
            let drinkType = sender as! String
            drinksTVC.drinkType = drinkType
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.drinks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DrinkCollectionViewCell
        cell.delegate = self
        cell.drink = self.drinks[indexPath.row]
        return cell
    }



}

extension DrinkMenuCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  32
        let collectionViewSize = self.collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension DrinkMenuCollectionViewController : DrinkDelegate {
    func selectedDrink(drink: String) {
        print("selected drink: \(drink)")
        //addLog(drink: drink)
        self.performSegue(withIdentifier: "Drinks", sender: drink)
    }
    
    
    private func addLog(drink: String){
        // Establish the AlertController
        let alertController = UIAlertController(title: drink, message: "\n", preferredStyle: .alert)
        alertController.isModalInPopover = true
        alertController.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "oz"
        })

        let confirmAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: ({
            (_) in
            if let field = alertController.textFields![0] as? UITextField {
                if field.text != "", let quantityINT = Int(field.text!) {
                    
                    if drink == "Coffee" {
                       self.saveCoffeeSample(value: quantityINT)
                    } else if drink == "Tea" {
                        self.saveTeaSample(value: quantityINT)
                    } else {
                       self.saveToHealthKit(value: quantityINT)
                    }
                    
                    

                }
            }
        }))

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        // present the alert into view
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension DrinkMenuCollectionViewController {
    private func saveToHealthKit(value: Int) {
        NutritionStore.save(value: value, completion: {
            (success, error) in
            if success {
                print("saved to HealthKit!")
            } else {
                print("NOT saved to HealthKit!")
            }
        })
    }
    
    private func saveCoffeeSample(value: Int){
        NutritionStore.saveCoffeeSample(value: value, completion: {
            (success, error) in
            if success {
                print("saved to HealthKit!")
            } else {
                print("NOT saved to HealthKit!")
            }
        })
    }
    
    private func saveTeaSample(value: Int){
        NutritionStore.saveTeaSample(value: value, completion: {
            (success, error) in
            if success {
                print("saved to HealthKit!")
            } else {
                print("NOT saved to HealthKit!")
            }
        })
    }
}
