//
//  LifeRingCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class LifeRingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    var lifeData : LifeData?{
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        print("lifeRignAwake")
        self.pieChart.noDataText = "There's no data today..."
        self.pieChart.legend.enabled = false
        self.pieChart.drawHoleEnabled = true
        self.pieChart.holeColor = NSUIColor.black
        self.pieChart.drawSlicesUnderHoleEnabled = true
        self.pieChart.usePercentValuesEnabled = true
        self.pieChart.holeRadiusPercent = 0.9
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        //self.pieChart.delegate = self
        //self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    private func updateView(){
        
        
        print("printing life ring")
        
        let pieChartDataEntry = PieChartDataEntry(value: self.lifeData!.percentCompleted!, icon: self.lifeData?.icon, data: self.lifeData?.data)
        let remainingPieChartDataEntry = PieChartDataEntry(value: 75.0, icon: nil, data: self.lifeData?.data)
        let chartDataSet = PieChartDataSet(entries: [pieChartDataEntry,remainingPieChartDataEntry], label: nil)
        chartDataSet.sliceSpace = 4.0
        chartDataSet.xValuePosition = .outsideSlice
        chartDataSet.yValuePosition = .outsideSlice
        chartDataSet.drawValuesEnabled = false
        chartDataSet.useValueColorForLine = false
        chartDataSet.valueLineColor = UIColor.clear
        chartDataSet.valueLinePart1Length = -0.2
        chartDataSet.valueLinePart2Length = -0.1
        //chartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 18.0)
        //chartDataSet.valueColors = [UIColor.Theme.salmon]
        let thisColor = self.lifeData?.color!
        let colors = [thisColor,thisColor?.withAlphaComponent(0.5)]
        chartDataSet.colors = colors as! [NSUIColor]
        chartDataSet.selectionShift = 0
        let chartData = PieChartData(dataSet: chartDataSet)
        
        
        self.pieChart.data = chartData
        
    }
    
}
