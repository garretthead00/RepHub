//
//  NutritionActivity_MacroProgressView.swift
//  RepHub
//
//  Created by Garrett Head on 3/21/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class NutritionActivity_MacroProgressView: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barChart: HorizontalBarChartView!
    @IBOutlet weak var valueLabel: UILabel!
    
    var macro : (String, Double, String)? {
        didSet {
            updateView()
        }
    }
    
    var macroTarget : Double? {
        didSet {
            updateView()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        valueLabel.text = ""
        macroTarget = 0.0
        

        let xAxis = barChart.xAxis
        let rightAxis = barChart.rightAxis
        let leftAxis = barChart.leftAxis
    
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = false
        xAxis.axisMinimum = 0
        xAxis.spaceMax = 0.0
        xAxis.spaceMin = 0.0
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0
        rightAxis.enabled = true
        rightAxis.drawAxisLineEnabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false
        rightAxis.axisMinimum = 0
        barChart.drawGridBackgroundEnabled = true
        barChart.gridBackgroundColor = UIColor.Theme.lavender.withAlphaComponent(0.5)
        barChart.noDataText = "..."
        barChart.legend.enabled = false
        barChart.drawValueAboveBarEnabled = false
        barChart.clipValuesToContentEnabled = true
        barChart.drawBarShadowEnabled = false
        barChart.fitBars = true
        barChart.animate(yAxisDuration: 1.25)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

extension NutritionActivity_MacroProgressView {
    
    private func updateView(){
        if let macro = macro {
            if let target = macroTarget {
                
                let title = macro.0
                let value = macro.1
                let unit = macro.2
                let remaining = target - value
                let axisMax = target > 0 ? target : value + 25
                self.barChart.leftAxis.axisMaximum = axisMax
                self.barChart.rightAxis.axisMaximum = axisMax
                
                
                let dataEntry = BarChartDataEntry(x: 1.0, yValues: [value])
                let dataSet = [dataEntry]
                let chartDataSet = BarChartDataSet(entries: dataSet, label: nil)
                let chartData = BarChartData(dataSet: chartDataSet)
                chartData.setDrawValues(true)
                chartData.barWidth = 2.0
                let colors = [NSUIColor(cgColor: UIColor.Theme.lavender.cgColor),NSUIColor(cgColor: UIColor.black.cgColor)]
                chartDataSet.colors = colors
               chartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 14.0)
                chartDataSet.valueTextColor = UIColor.white
                chartDataSet.drawValuesEnabled = true
                self.barChart.data = chartData
                self.titleLabel.text = title
                self.valueLabel.text = "\(Int(value)) \(unit)"
                
            }
        }
        
        
    }
}
