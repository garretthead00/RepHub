//
//  EnergyBalanceCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 10/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class EnergyBalanceCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var energyBalanceCombinedChart: CombinedChartView!
    
    var message : String? {
        didSet {
            self.updateView()
        }
    }
    
    
    var dataSet1 = [123, 154, 164, 134, 122, 111]
    var dataSet2 = [131, 175, 110, 143, 102, 111]
    var dataSet3 = [100, 102, 122, 112, 134, 123]
    var x = ["1", "2", "3", "4", "5", "6"]
    
    private func updateView(){
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.setupChart()

        
      
        
    }
    
}

extension EnergyBalanceCollectionViewCell {
    
    private func setupChart(){
        self.energyBalanceCombinedChart.noDataText = "No data..."
        self.energyBalanceCombinedChart.drawBarShadowEnabled = false
        self.energyBalanceCombinedChart.animate(yAxisDuration: 1.25, easingOption: .easeInBounce)
        
    }
}
