//
//  NutritionActivityMacroOverview.swift
//  RepHub
//
//  Created by Garrett Head on 3/14/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class NutritionActivityMacroOverview: UITableViewCell {

    @IBOutlet weak var pieChart: PieChartView!
    var macros : [(String, Double, String)]? {
        didSet {
            self.updateView()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pieChart.legend.enabled = false
        self.pieChart.usePercentValuesEnabled = true
        self.pieChart.chartDescription?.enabled = false
        self.pieChart.noDataText = "There's no data today."
        self.pieChart.drawHoleEnabled = false
        self.pieChart.drawSlicesUnderHoleEnabled = false
        self.pieChart.holeColor = UIColor.black
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        
    }

}

extension NutritionActivityMacroOverview {
    private func updateView(){
        var dataSet = [PieChartDataEntry]()
        var colors = [NSUIColor]()
        colors.append(NSUIColor(cgColor: UIColor.Theme.salmon.cgColor))
        colors.append(NSUIColor(cgColor: UIColor.Theme.banana.cgColor))
        colors.append(NSUIColor(cgColor: UIColor.Theme.spring.cgColor))
        if let macros = self.macros {
            for macro in macros {
                dataSet.append(PieChartDataEntry(value: macro.1, icon: UIImage(named: macro.0.lowercased())))
            }
        }
        let chartDataSet = PieChartDataSet(entries: dataSet, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.colors = colors
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawIconsEnabled = true
        self.pieChart.data = chartData
    }
}
