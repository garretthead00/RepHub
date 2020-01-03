//
//  ActivityCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 10/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts


class ActivityCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressChartView: PieChartView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var itemOneTitleLabel: UILabel!
    @IBOutlet weak var itemOneValueLabel: UILabel!
    @IBOutlet weak var itemTwoTitleLabel: UILabel!
    @IBOutlet weak var itemTwoValueLabel: UILabel!
    @IBOutlet weak var itemThreeTitleLabel: UILabel!
    @IBOutlet weak var itemThreeValueLabel: UILabel!

    var delegate : ActivityDelegate?
    var activity : Activity? {
        didSet {
            updateView()
        }
    }

    var chartDataSet = PieChartDataSet()
    
    
    override func awakeFromNib() {
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.iconImageView.image = nil
        self.titleLabel.text = ""
        self.progressLabel.text = ""
        self.itemOneTitleLabel.text = ""
        self.itemTwoTitleLabel.text = ""
        self.itemThreeTitleLabel.text = ""
        self.itemOneValueLabel.text = ""
        self.itemTwoValueLabel.text = ""
        self.itemThreeValueLabel.text = ""
        self.itemOneTitleLabel.textColor = UIColor.lightText
        self.itemTwoTitleLabel.textColor = UIColor.lightText
        self.itemThreeTitleLabel.textColor = UIColor.lightText
        self.itemOneValueLabel.textColor = UIColor.lightText
        self.itemTwoValueLabel.textColor = UIColor.lightText
        self.itemThreeValueLabel.textColor = UIColor.lightText
        self.chartDataSet.sliceSpace = 4.0
        self.chartDataSet.xValuePosition = .insideSlice
        self.chartDataSet.yValuePosition = .insideSlice
        self.chartDataSet.drawValuesEnabled = false
        self.chartDataSet.useValueColorForLine = false
        self.chartDataSet.valueLineColor = UIColor.clear
        self.chartDataSet.valueLinePart1Length = -0.2
        self.chartDataSet.valueLinePart2Length = -0.1
        self.chartDataSet.label = nil
        self.chartDataSet.selectionShift = 0
        
        self.setupCharts()
    }
    
    private func updateView(){
        
        
        if let activity = self.activity {

            self.iconImageView.image = activity.icon
            self.titleLabel.text = activity.label
            self.progressLabel.text = "\(self.activity!.dailyTotal ?? 0.0) / \(activity.target!) \(activity.unit)"
            self.titleLabel.textColor = activity.color
            self.progressLabel.textColor =  UIColor.white
            let percentComplete = activity.percentComplete ?? 0.0
            let percentRemaining = activity.percentRemaining ?? 0.0
            let pieChartDataEntry = PieChartDataEntry(value: percentComplete, icon: nil, data: activity.label)
            let remainingPieChartDataEntry = PieChartDataEntry(value: percentRemaining, icon: nil, data: activity.label)
            let colors = [activity.color,activity.color.withAlphaComponent(0.5)]
            self.chartDataSet.replaceEntries([pieChartDataEntry,remainingPieChartDataEntry])
            self.chartDataSet.colors = colors
            let chartData = PieChartData(dataSet: chartDataSet)
            self.progressChartView.data = chartData

            
            if let data = self.activity?.summaryData[0] {
                self.itemOneTitleLabel.text = "\(data.0)"
                self.itemOneValueLabel.text = "\(String(format: "%.0f", data.1)) \(data.2)"
            }
            if let data = self.activity?.summaryData[1] {
                self.itemTwoTitleLabel.text = "\(data.0)"
                self.itemTwoValueLabel.text = "\(String(format: "%.0f", data.1)) \(data.2)"
            }
            if let data = self.activity?.summaryData[2] {
                self.itemThreeTitleLabel.text = "\(data.0)"
                self.itemThreeValueLabel.text = "\(String(format: "%.0f", data.1)) \(data.2)"
            }
            
        }
    }
    
}

extension ActivityCollectionViewCell {
    
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
