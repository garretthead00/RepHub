//
//  ActivityLineChartView.swift
//  RepHub
//
//  Created by Garrett Head on 2/2/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class ActivityLineChartView: UITableViewCell {
    @IBOutlet weak var chart: LineChartView!
    
    var waterDrank : [Double]? {
        didSet {
            self.updateView()
        }
    }
    var hydrationTarget : Double?
    
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
        
        self.chart.noDataText = "Drink some water!"
        self.chart.legend.enabled = false
        self.chart.animate(yAxisDuration: 1.25, easingOption: .easeInBounce)
    }

    
    private func updateView() {
        let data = generateLineData()
        self.chart.data = data
    }

}

extension ActivityLineChartView {
    func generateLineData() -> LineChartData {
        if let hydration = self.waterDrank {
            let dataSets = (0..<2).map { set -> LineChartDataSet in
                let entries = (0..<hydration.count).map { (i) -> ChartDataEntry in
                    if set == 0 {
                        return ChartDataEntry(x: Double(i) + 0.5, y: hydration[i])
                    } else {
                        return ChartDataEntry(x: Double(i) + 0.5, y: hydrationTarget!)
                    }
                    
                }
                let dataSet = LineChartDataSet(entries: entries, label: "DataSet \(set)")
                if set == 0 {
                    dataSet.setColor(UIColor.Theme.Activity.hydrate)
                    dataSet.drawFilledEnabled = true
                    dataSet.fillColor = UIColor.Theme.Activity.hydrate.withAlphaComponent(0.8)
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
