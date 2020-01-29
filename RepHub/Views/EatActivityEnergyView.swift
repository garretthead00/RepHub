//
//  EatActivityEnergyView.swift
//  RepHub
//
//  Created by Garrett Head on 1/12/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class EatActivityEnergyView: UITableViewCell {

    @IBOutlet weak var barChart: BarChartView!
    
    var consumed = [
        (Date(), 0.0, "g"),
        (Date(), 0.0, "g"),
        (Date(), 0.0, "g"),
        (Date(), 0.0, "g"),
        (Date(), 0.0, "g"),
        (Date(), 10.0, "g"),
        (Date(), 27.0, "g"),
        (Date(), 13.0, "g"),
        (Date(), 60.0, "g"),
        (Date(), 2.0, "g"),
        (Date(), 10.0, "g"),
        (Date(), 32.0, "g"),
        (Date(), 13.0, "g"),
        (Date(), 45.0, "g"),
        (Date(), 22.0, "g"),
        (Date(), 10.0, "g"),
        (Date(), 7.0, "g"),
        (Date(), 32.0, "g"),
        (Date(), 45.0, "g"),
        (Date(), 21.0, "g"),
        (Date(), 0.0, "g"),
        (Date(), 0.0, "g"),
        (Date(), 0.0, "g"),
        (Date(), 0.0, "g"),
    ]
    
    var energyConsumed : [(Date, Double, String)]? {
        didSet {
            self.updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.barChart.legend.enabled = false
        self.barChart.drawGridBackgroundEnabled = false
        self.barChart.leftAxis.drawGridLinesEnabled = false
        self.barChart.leftAxis.drawAxisLineEnabled = true
        self.barChart.leftAxis.drawLabelsEnabled = false
        self.barChart.rightAxis.drawGridLinesEnabled = true
        self.barChart.rightAxis.drawAxisLineEnabled = true
        self.barChart.rightAxis.labelTextColor = UIColor.lightText
        self.barChart.xAxis.drawAxisLineEnabled = true
        self.barChart.xAxis.drawGridLinesEnabled = false
        self.barChart.xAxis.labelTextColor = UIColor.lightText
        self.barChart.xAxis.labelPosition = .bottom
        
        self.barChart.animate(yAxisDuration: 1.25, easingOption: .easeInBounce)
        
        
        
        
        // REMOVE: After full controller integration...
        self.energyConsumed = self.consumed

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    private func updateView() {
        let data = generateBarData()
        self.barChart.data = data
        
    }
    
    
    
    func generateBarData() -> BarChartData {
        if let energyConsumed = self.energyConsumed {
            let entries = (0..<energyConsumed.count).map { (i) -> BarChartDataEntry in
                return BarChartDataEntry(x: Double(i) + 0.5, yValues: [energyConsumed[i].1])
                
            }

            let set = BarChartDataSet(entries: entries, label: "")
            set.axisDependency = .left
            set.drawValuesEnabled = false
            set.stackLabels = ["Consumed"]
            set.valueColors = [UIColor.Theme.Activity.eat]
            set.colors = [UIColor.Theme.Activity.eat]
            
            // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
            //let groupSpace = 0.0
            //let barSpace = 0.4 // x2 dataset
            let barWidth = 0.6 // x2 dataset
            
            // make this BarData object grouped
            let data = BarChartData(dataSets: [set])
            data.barWidth = barWidth
           // data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
            return data
        }
        return BarChartData(dataSets: nil)
    }
    

}
