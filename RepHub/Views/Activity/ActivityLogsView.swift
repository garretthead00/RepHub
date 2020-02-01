//
//  ActivityLogsView.swift
//  RepHub
//
//  Created by Garrett Head on 1/30/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class ActivityLogsView: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var logs : [NutritionLog]? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    
    private func updateView(){
        print("got logs \(logs?.count)")
        collectionView.reloadData()
    }

}

extension ActivityLogsView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return logs!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogView", for: indexPath) as! HydrationLogView
        cell.log = logs![indexPath.row]
        return cell
    }
    

     
}

extension ActivityLogsView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128.0, height: 128.0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 2)
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    

}

