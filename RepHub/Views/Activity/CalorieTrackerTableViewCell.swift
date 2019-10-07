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
    
    var activity : Activity? {
        didSet {
            self.setChartData()
        }
    }
    
    var calorieData : [BarChartDataEntry]? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("calorie tracker awake")
        self.setupChart()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setChartData() {
//
        
    }
    
    private func updateView(){
        
        let chartDataSet = BarChartDataSet(entries: self.calorieData, label: nil)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.drawValuesEnabled = false
        chartDataSet.valueColors = [self.activity!.color]
        chartDataSet.colors = [self.activity!.color]
        chartDataSet.axisDependency = .left
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
