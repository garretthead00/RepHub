//EatActivityEnergyView
//  HydrationActivityView.swift
//  RepHub
//
//  Created by Garrett Head on 2/1/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class HydrationActivityView: UITableViewCell {

    @IBOutlet weak var chart: BarChartView!
    var waterDrank : [Double]? {
        didSet {
            self.updateView()
        }
    }
    
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

        let rightAxis = self.chart.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        
        self.chart.noDataText = "Drink some water!"
        self.chart.legend.enabled = false
        self.chart.drawValueAboveBarEnabled = false
        self.chart.drawBarShadowEnabled = false
        self.chart.fitBars = true
        self.chart.animate(yAxisDuration: 1.25, easingOption: .easeInBounce)
        
        // REMOVE: After full controller integration...
       // self.waterDrank = self.consumed

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateView() {
        let data = generateBarData()
        self.chart.data = data
    }
    
    func generateBarData() -> BarChartData {
        if let water = self.waterDrank {
            let entries = (0..<water.count).map { (i) -> BarChartDataEntry in
                return BarChartDataEntry(x: Double(i) + 0.5, yValues: [water[i], water[i] * -1])
            }
            let set = BarChartDataSet(entries: entries, label: "")
            set.axisDependency = .left
            set.drawValuesEnabled = false
            set.stackLabels = ["Drank"]
            set.valueColors = [UIColor.Theme.Activity.hydrate]
            set.colors = [UIColor.Theme.Activity.hydrate]
            let barWidth = 0.8 // x2 dataset
            let data = BarChartData(dataSets: [set])
            data.barWidth = barWidth
            return data
        }
        return BarChartData(dataSets: nil)
    }

}
