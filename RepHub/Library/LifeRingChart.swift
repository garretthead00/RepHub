//
//  LifeRingChart.swift
//  RepHub
//
//  Created by Garrett Head on 9/17/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation
import Charts

class LifeRingChartView : PieChartView {

    convenience override init(frame: CGRect) {
        print("Got here!")
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: 128.0, height: 128.0))
        self.noDataText = "No data"
        self.legend.enabled = false
        self.drawHoleEnabled = true
        self.holeColor = NSUIColor.red
        self.drawSlicesUnderHoleEnabled = true
        self.usePercentValuesEnabled = true
        self.holeRadiusPercent = 0.9
        self.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        //self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
}

extension LifeRingChartView {
    
    

    
}


