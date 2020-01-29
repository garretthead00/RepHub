//
//  ActivityProgressView.swift
//  RepHub
//
//  Created by Garrett Head on 1/12/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class ActivityProgressView: UITableViewCell {
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var label: UILabel!
    
    var colorTheme : UIColor? {
        didSet {
            self.updateView()
        }
    }
    
    var progressPercent : Int? {
        didSet {
            self.updateView()
        }
    }
    var progress : Double? {
        didSet {
            self.updateView()
        }
    }
    var activityTarget : Double? {
        didSet {
            self.updateView()
        }
    }
    var calorieEntries = [PieChartDataEntry]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.text = ""
        self.pieChart.noDataText = "There's no data today..."
        self.pieChart.legend.enabled = false
        self.pieChart.drawHoleEnabled = true
        self.pieChart.drawSlicesUnderHoleEnabled = true
        self.pieChart.usePercentValuesEnabled = true
        self.pieChart.holeRadiusPercent = 0.8
        self.pieChart.holeColor = UIColor.black
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView(){
        if let progress = self.progress, let target = self.activityTarget {
            self.label.text = "\(progress) / \(target) kCals"
        }
        
        // update chart
        if let progressPercent = self.progressPercent {
            let remainingPercent = 100 - progressPercent
            let percentComplete = PieChartDataEntry(value: Double(progressPercent))
            let percentremaining = PieChartDataEntry(value: Double(remainingPercent))
            self.calorieEntries = [percentComplete, percentremaining]
            
            let chartDataSet = PieChartDataSet(entries: self.calorieEntries, label: nil)
            let chartData = PieChartData(dataSet: chartDataSet)
            
            if let color = self.colorTheme {
                chartDataSet.colors = [color, color.withAlphaComponent(0.5)]
            }
            chartDataSet.sliceSpace = 2.0
            chartDataSet.drawValuesEnabled = false
            self.pieChart.data = chartData
            chartDataSet.selectionShift = 0
        }
        
    }

}
