//
//  EatCaloriesTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/23/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts


class EatCaloriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var caloriesBarChart: HorizontalBarChartView!
    private var caloriesDataEntry : BarChartDataEntry?
    private var caloriesRemainingDataEntry : BarChartDataEntry?
    var dataSet = [BarChartDataEntry]()
    
    var caloriesConsumed : Double?
    var caloriesRemaining : Double? {
        didSet {
            self.updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.caloriesConsumed = 0.0
        self.caloriesRemaining = 0.0
        
        // Set Chart parameters
        self.caloriesBarChart.noDataText = "Eat up...There's no data today."
        self.caloriesBarChart.legend.enabled = false
        self.caloriesBarChart.animate(yAxisDuration: 1.25)
        //self.caloriesBarChart.fitBars = true
        self.caloriesBarChart.drawValueAboveBarEnabled = false
        
        
        // Set Axis parameters
        self.caloriesBarChart.leftAxis.drawAxisLineEnabled = false
        self.caloriesBarChart.leftAxis.drawGridLinesEnabled = false
        self.caloriesBarChart.leftAxis.drawLabelsEnabled = false
        self.caloriesBarChart.rightAxis.drawAxisLineEnabled = false
        self.caloriesBarChart.rightAxis.drawGridLinesEnabled = false
        self.caloriesBarChart.rightAxis.drawLabelsEnabled = false
        self.caloriesBarChart.xAxis.drawAxisLineEnabled = false
        self.caloriesBarChart.xAxis.drawGridLinesEnabled = false
        self.caloriesBarChart.xAxis.drawLabelsEnabled = false
        self.caloriesBarChart.xAxis.labelPosition = .bottomInside
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView() {
        self.caloriesBarChart.leftAxis.axisMinimum = 0
        self.caloriesBarChart.leftAxis.axisMaximum = self.caloriesConsumed! + self.caloriesRemaining!
        self.caloriesBarChart.rightAxis.axisMinimum = 0
        self.caloriesBarChart.rightAxis.axisMaximum = self.caloriesConsumed! + self.caloriesRemaining!
        self.caloriesDataEntry = BarChartDataEntry(x: 1.0, yValues: [self.caloriesConsumed!,self.caloriesRemaining!])
        self.dataSet = [self.caloriesDataEntry!]
        
        let chartDataSet = BarChartDataSet(entries: self.dataSet, label: nil)
        let chartData = BarChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: UIColor.Theme.seaFoam.cgColor), NSUIColor(cgColor: UIColor.Theme.sky.cgColor)]
        chartDataSet.colors = colors
        chartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 14.0)
        self.caloriesBarChart.data = chartData
    }

}
