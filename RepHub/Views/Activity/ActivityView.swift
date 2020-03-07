//
//  ActivityView.swift
//  RepHub
//
//  Created by Garrett Head on 1/25/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class ActivityView: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var chartIcon: UIImageView!
    
    
//    var activity : Activity? {
//        didSet {
//            self.updateView()
//        }
//    }
    
    
    var name : String? {
        didSet {
            self.updateView()
        }
    }
    var iconImage : UIImage? {
        didSet {
            self.updateView()
        }
    }
    var color : UIColor? {
        didSet {
            self.updateView()
        }
    }
    var total : Double? {
        didSet {
            self.updateView()
        }
    }
    var remaining : Double? {
        didSet {
            self.updateView()
        }
    }
    var unit : String? {
        didSet {
            self.updateView()
        }
    }
    var chartDataSet = PieChartDataSet()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.text = ""
        self.value.text = ""
        self.remainingLabel.text = ""
        
        self.chartDataSet.sliceSpace = 4.0
        self.chartDataSet.xValuePosition = .insideSlice
        self.chartDataSet.yValuePosition = .insideSlice
        self.chartDataSet.drawValuesEnabled = false
        self.chartDataSet.useValueColorForLine = false
        self.chartDataSet.valueLineColor = UIColor.clear
        self.chartDataSet.valueLinePart1Length = -0.2
        self.chartDataSet.valueLinePart2Length = -0.1
        self.chartDataSet.label = nil
        self.chartDataSet.selectionShift = 0
        
        self.setupCharts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    private func updateView(){
        var colors = [UIColor]()
        if let name = self.name {
            self.label.text = "\(name)"
        }
        if let icon = self.iconImage {
           self.chartIcon.image = icon
        }
        if let color = self.color {
            let colors = [color,color.withAlphaComponent(0.5)]
            self.chartDataSet.colors = colors
            self.value.textColor = color
        }
        
        if let total = self.total, let unit = self.unit, let remaining = self.remaining {
            self.value.text = "\(Int(total)) \(unit)"
            self.remainingLabel.text = "\(Int(remaining)) \(unit) left to goal."
            let pieChartDataEntry = PieChartDataEntry(value: total)
            let remainingPieChartDataEntry = PieChartDataEntry(value: remaining)
            self.chartDataSet.replaceEntries([pieChartDataEntry,remainingPieChartDataEntry])
            let chartData = PieChartData(dataSet: chartDataSet)
            self.pieChart.data = chartData
            
        }

        
        
        
        
    }
    
}

extension ActivityView {
    
    private func setupCharts(){
        self.pieChart.noDataText = "There's no data today..."
        self.pieChart.legend.enabled = false
        self.pieChart.drawHoleEnabled = true
        self.pieChart.holeColor = NSUIColor.black
        self.pieChart.drawSlicesUnderHoleEnabled = true
        self.pieChart.usePercentValuesEnabled = false
        self.pieChart.holeRadiusPercent = 0.9
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        
    }
    
}
