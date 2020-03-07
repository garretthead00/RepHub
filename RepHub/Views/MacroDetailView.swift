//
//  MacroDetailView.swift
//  RepHub
//
//  Created by Garrett Head on 1/12/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class MacroDetailView: UITableViewCell {


    @IBOutlet weak var horizontalBarChart: HorizontalBarChartView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var total : (String, Double, String)? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.text = ""
        self.valueLabel.text = ""
        // Set Chart parameters
        
        

        let xAxis = self.horizontalBarChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 10
        xAxis.axisMinimum = 0
        
        let leftAxis = self.horizontalBarChart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0

        let rightAxis = self.horizontalBarChart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        rightAxis.axisMinimum = 0
        
        self.horizontalBarChart.gridBackgroundColor = UIColor.black
        self.horizontalBarChart.noDataText = "..."
        self.horizontalBarChart.legend.enabled = false
        self.horizontalBarChart.drawValueAboveBarEnabled = false
        self.horizontalBarChart.drawBarShadowEnabled = false
        self.horizontalBarChart.fitBars = true
        self.horizontalBarChart.animate(yAxisDuration: 1.25)
        
        

        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView() {
        if let total = self.total {
            self.horizontalBarChart.leftAxis.axisMaximum = total.1 + 25
            self.horizontalBarChart.rightAxis.axisMaximum = total.1 + 25
            let remaining = (total.1 + 25) - total.1
            let dataEntry = BarChartDataEntry(x: 1.0, yValues: [total.1, remaining])
            let dataSet = [dataEntry]
            let chartDataSet = BarChartDataSet(entries: dataSet, label: nil)
            let chartData = BarChartData(dataSet: chartDataSet)
            chartData.barWidth = 9.0
            let colors = [NSUIColor(cgColor: UIColor.Theme.lavender.cgColor),NSUIColor(cgColor: UIColor.black.cgColor)]
            chartDataSet.colors = colors
            chartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 14.0)
            chartDataSet.drawValuesEnabled = false
            self.horizontalBarChart.data = chartData
            self.nameLabel.text = total.0
            self.valueLabel.text = "\(Int(total.1)) \(total.2)"
        }

    }

}
