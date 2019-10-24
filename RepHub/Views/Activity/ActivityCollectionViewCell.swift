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

    
    //var delegate : ActivityDelegate?
    
    var activity : Activity? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
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
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.setupCharts()
    }
    
    private func updateView(){
        
        if let activity = self.activity {

            self.iconImageView.image = activity.icon
            self.titleLabel.text = activity.label
            self.progressLabel.text = "\(activity.dailyTotal) / \(activity.target) \(activity.unit)"
            self.titleLabel.textColor = activity.color
            self.progressLabel.textColor = activity.color
            self.layer.borderColor = activity.color.withAlphaComponent(0.5).cgColor
            let percentComplete = activity.percentComplete ?? 0.0
            let percentRemaining = activity.percentRemaining ?? 0.0
            let pieChartDataEntry = PieChartDataEntry(value: percentComplete, icon: nil, data: activity.label)
            let remainingPieChartDataEntry = PieChartDataEntry(value: percentRemaining, icon: nil, data: activity.label)
            let colors = [activity.color,activity.color.withAlphaComponent(0.5)]
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
             
            if activity.data.count > 0 {
                self.itemOneTitleLabel.text = "\(activity.data[0].0)"
                self.itemOneValueLabel.text = "\(String(format: "%.0f", activity.data[0].1)) \(activity.data[0].2)"
                self.itemTwoTitleLabel.text = "\(activity.data[1].0)"
                self.itemTwoValueLabel.text = "\(String(format: "%.0f", activity.data[1].1)) \(activity.data[1].2)"
                self.itemThreeTitleLabel.text = "\(activity.data[2].0)"
                self.itemThreeValueLabel.text = "\(String(format: "%.0f", activity.data[2].1)) \(activity.data[2].2)"
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
        //self.progressChartView.delegate = self
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
    }
    
}
