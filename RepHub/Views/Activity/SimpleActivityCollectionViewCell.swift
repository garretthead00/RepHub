//
//  SimpleActivityCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 10/21/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class SimpleActivityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressChartView: PieChartView!
    
    var delegate : ActivityDelegate?
    
    var activity : Activity? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        self.iconImageView.image = nil
        self.titleLabel.text = ""
        self.progressLabel.text = ""
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.setupCharts()
    }
    
    private func updateView(){
        print("Simple ActivityCollectionViewCell Hey!")
        self.iconImageView.image = self.activity?.icon
        self.titleLabel.text = self.activity?.label
        self.progressLabel.text = "\(self.activity!.dailyTotal) / \(self.activity!.target) \(self.activity!.unit)"
        self.titleLabel.textColor = self.activity?.color
        self.progressLabel.textColor = self.activity?.color
        self.layer.borderColor = self.activity!.color.withAlphaComponent(0.5).cgColor
        
        
        let percentComplete = self.activity?.percentComplete ?? 0.0
        let percentRemaining = self.activity?.percentRemaining ?? 0.0
        
        let pieChartDataEntry = PieChartDataEntry(value: percentComplete, icon: nil, data: self.activity!.label)
        let remainingPieChartDataEntry = PieChartDataEntry(value: percentRemaining, icon: nil, data: self.activity!.label)
        let colors = [self.activity!.color,self.activity!.color.withAlphaComponent(0.5)]
        let chartDataSet = PieChartDataSet(entries: [pieChartDataEntry,remainingPieChartDataEntry], label: nil)
        chartDataSet.sliceSpace = 4.0
        chartDataSet.xValuePosition = .insideSlice
        chartDataSet.yValuePosition = .insideSlice
        chartDataSet.drawValuesEnabled = false
        chartDataSet.useValueColorForLine = false
        chartDataSet.valueLineColor = UIColor.clear
        chartDataSet.valueLinePart1Length = -0.2
        chartDataSet.valueLinePart2Length = -0.1
        chartDataSet.colors = colors
        chartDataSet.selectionShift = 0
        let chartData = PieChartData(dataSet: chartDataSet)
        self.progressChartView.data = chartData
         
    }
    
}

extension SimpleActivityCollectionViewCell {
    
    private func setupCharts(){
        self.progressChartView.noDataText = "There's no data today..."
        self.progressChartView.legend.enabled = false
        self.progressChartView.drawHoleEnabled = true
        self.progressChartView.holeColor = NSUIColor.black
        self.progressChartView.drawSlicesUnderHoleEnabled = true
        self.progressChartView.usePercentValuesEnabled = true
        self.progressChartView.holeRadiusPercent = 0.9
        self.progressChartView.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
    }
    
}
