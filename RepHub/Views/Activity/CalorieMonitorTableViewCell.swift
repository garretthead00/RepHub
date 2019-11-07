//
//  CalorieMonitorTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/19/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class CalorieMonitorTableViewCell: UITableViewCell {

    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var label: UILabel!

    
    var activity : Activity? {
        didSet {
            self.setChartData()
        }
    }
    
    var calorieEntries : [PieChartDataEntry]? {
        didSet{
            updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("calorie monitor awake")
        self.setupCharts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    private func setChartData() {
        let percentComplete = PieChartDataEntry(value: self.activity!.percentComplete!)
        let percentremaining = PieChartDataEntry(value: self.activity!.percentRemaining!)
        self.calorieEntries = [percentComplete, percentremaining]
    }
    
    private func updateView(){
        self.label.text = "\(self.activity!.dailyTotal) / \(self.activity!.target) \(self.activity!.unit)"
        let chartDataSet = PieChartDataSet(entries: self.calorieEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.colors = [self.activity!.color, self.activity!.color.withAlphaComponent(0.5)]
        chartDataSet.sliceSpace = 2.0
        chartDataSet.drawValuesEnabled = false
        self.pieChart.data = chartData
        chartDataSet.selectionShift = 0
    }

}

extension CalorieMonitorTableViewCell {
    private func setupCharts(){
        self.pieChart.noDataText = "There's no data today..."
        self.pieChart.legend.enabled = false
        self.pieChart.drawHoleEnabled = true
        self.pieChart.drawSlicesUnderHoleEnabled = true
        self.pieChart.usePercentValuesEnabled = true
        self.pieChart.holeRadiusPercent = 0.8
        self.pieChart.holeColor = UIColor.black
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
   
    }
}
