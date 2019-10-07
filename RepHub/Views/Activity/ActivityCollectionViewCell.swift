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
        print("ActivityCollectionViewCell Hey!")
        self.iconImageView.image = self.activity?.icon
        self.titleLabel.text = self.activity?.label
        self.progressLabel.text = "\(self.activity!.dailyTotal!) / \(self.activity!.target!) \(self.activity!.unit!)"
        self.itemOneTitleLabel.text = "steps"
        self.itemTwoTitleLabel.text = "exercise"
        self.itemThreeTitleLabel.text = "stand"
        self.itemOneValueLabel.text = "4,335"
        self.itemTwoValueLabel.text = "17"
        self.itemThreeValueLabel.text = "6"
        self.titleLabel.textColor = self.activity?.color
        self.progressLabel.textColor = self.activity?.color
        self.layer.borderColor = self.activity!.color.withAlphaComponent(0.5).cgColor
        
        
        
        let pieChartDataEntry = PieChartDataEntry(value: self.activity!.percentComplete!, icon: nil, data: self.activity!.label)
        let remainingPieChartDataEntry = PieChartDataEntry(value: self.activity!.percentRemaining!, icon: nil, data: self.activity!.label)
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
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.init(name: "Damascus", size: 12.0)!,
//            .foregroundColor: self.activity!.color,
//        ]
//        let str = Int(self.activity!.percentComplete!)
//        let myAttrString = NSAttributedString(string: "\(str)%", attributes: attributes)
//        self.progressChartView.centerAttributedText = myAttrString
        self.progressChartView.data = chartData
        
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
