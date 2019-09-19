//
//  CalorieTrackerTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/19/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts


class CalorieTrackerTableViewCell: UITableViewCell {

    @IBOutlet weak var barChart: BarChartView!
    
    var calorieDataEntries = [
        BarChartDataEntry(x: 0.0, y: 0.0),
        BarChartDataEntry(x: 1.0, y: 0.0),
        BarChartDataEntry(x: 2.0, y: 0.0),
        BarChartDataEntry(x: 3.0, y: 0.0),
        BarChartDataEntry(x: 4.0, y: 0.0),
        BarChartDataEntry(x: 5.0, y: 0.0),
        BarChartDataEntry(x: 6.0, y: 25.0),
        BarChartDataEntry(x: 7.0, y: 55.0),
        BarChartDataEntry(x: 8.0, y: 32.0),
        BarChartDataEntry(x: 9.0, y: 72.0),
        BarChartDataEntry(x: 10.0, y: 56.0),
        BarChartDataEntry(x: 11.0, y: 43.0),
        BarChartDataEntry(x: 12.0, y: 45.0),
        BarChartDataEntry(x: 13.0, y: 36.0),
        BarChartDataEntry(x: 14.0, y: 12.0),
        BarChartDataEntry(x: 15.0, y: 12.0),
        BarChartDataEntry(x: 16.0, y: 42.0),
        BarChartDataEntry(x: 17.0, y: 51.0),
        BarChartDataEntry(x: 18.0, y: 37.0),
        BarChartDataEntry(x: 19.0, y: 0.0),
        BarChartDataEntry(x: 20.0, y: 0.0),
        BarChartDataEntry(x: 21.0, y: 0.0),
        BarChartDataEntry(x: 22.0, y: 0.0),
        BarChartDataEntry(x: 23.0, y: 0.0),
        BarChartDataEntry(x: 24.0, y: 0.0)
    ]
    
    var calorieData : [BarChartDataEntry]? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("calorie tracker awake")
        self.setupChart()
        self.calorieData = self.calorieDataEntries
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateView(){
        
        let chartDataSet = BarChartDataSet(entries: self.calorieDataEntries, label: nil)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueColors = [UIColor.Theme.salmon]
        chartDataSet.colors = [UIColor.Theme.salmon]
        self.barChart.data = chartData        
        
    }
}

extension CalorieTrackerTableViewCell {
    
    private func setupChart(){
        self.barChart.legend.enabled = false
        self.barChart.drawGridBackgroundEnabled = false
        self.barChart.leftAxis.drawGridLinesEnabled = true
        self.barChart.rightAxis.drawGridLinesEnabled = false
        self.barChart.leftAxis.drawAxisLineEnabled = true
        self.barChart.rightAxis.drawAxisLineEnabled = true
        self.barChart.xAxis.drawAxisLineEnabled = true
        self.barChart.xAxis.drawGridLinesEnabled = false
        self.barChart.animate(yAxisDuration: 1.25, easingOption: .easeInBounce)
        
    }
    
}
