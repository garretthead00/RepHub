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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

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
        addLog(drink: drink)
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
