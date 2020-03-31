//
//  ActivityRollingTotalView.swift
//  RepHub
//
//  Created by Garrett Head on 3/14/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class ActivityRollingTotalView: UITableViewCell {
    
    @IBOutlet weak var chart: LineChartView!
    
    var rollingTotal : [Double]? {
        didSet {
            self.updateView()
        }
    }
    var activityTarget : Double?
    var activityColor : UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
        let xAxis = self.chart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.drawLabelsEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 24
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 6
        xAxis.labelTextColor = UIColor.lightGray
        
        let leftAxis = self.chart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawLabelsEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawZeroLineEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.labelTextColor = UIColor.lightGray

        let rightAxis = self.chart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.axisMinimum = 0
        
        self.chart.noDataText = "No Data"
        self.chart.legend.enabled = false
        self.chart.animate(yAxisDuration: 1.25, easingOption: .easeInBounce)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    private func updateView() {
        let data = generateLineData()
        self.chart.data = data
    }
    
}

extension ActivityRollingTotalView {
    
    func generateLineData() -> LineChartData {
        if let rollingTotal = self.rollingTotal {
            let dataSets = (0..<2).map { set -> LineChartDataSet in
                let entries = (0..<rollingTotal.count).map { (i) -> ChartDataEntry in
                    if set == 0 {
                        return ChartDataEntry(x: Double(i) + 0.5, y: rollingTotal[i])
                    } else {
                        return ChartDataEntry(x: Double(i) + 0.5, y: activityTarget!)
                    }
                    
                }
                let dataSet = LineChartDataSet(entries: entries, label: "DataSet \(set)")
                if set == 0 {
                    dataSet.setColor(activityColor!)
                    dataSet.drawFilledEnabled = true
                    dataSet.fillColor = activityColor!.withAlphaComponent(0.8)
                } else {
                    dataSet.setColor(UIColor.Theme.Activity.exercise)
                }
                dataSet.lineWidth = 1.0
                dataSet.circleRadius = 0.0
                dataSet.circleHoleRadius = 0.0
                dataSet.drawValuesEnabled = true
                dataSet.axisDependency = .left
                dataSet.drawValuesEnabled = false
                return dataSet
            }
            
            let data = LineChartData(dataSets: dataSets)
            data.setValueFont(.systemFont(ofSize: 7, weight: .light))
            chart.data = data
            return data
        }
         return LineChartData(dataSet: nil)
    }
}
