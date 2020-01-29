//
//  DrinksByTypeView.swift
//  RepHub
//
//  Created by Garrett Head on 1/13/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class DrinksByTypeView: UITableViewCell {
    @IBOutlet weak var pieChart: PieChartView!

    var drinksByType : [String:Double]? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pieChart.legend.enabled = false
        self.pieChart.usePercentValuesEnabled = false
        self.pieChart.chartDescription?.enabled = false
        self.pieChart.noDataText = "Drink up...There's no data today."
        self.pieChart.drawHoleEnabled = true
        self.pieChart.drawSlicesUnderHoleEnabled = true
        self.pieChart.holeColor = UIColor.black
        self.pieChart.holeRadiusPercent = 0.5
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.Theme.aqua,
            .font: UIFont.systemFont(ofSize: 36)
        ]
        let firstString = NSMutableAttributedString(string: "", attributes: firstAttributes)
        self.pieChart.centerAttributedText = firstString
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView() {
        var dataSet = [PieChartDataEntry]()
        if let drinksByType = self.drinksByType {
            for (key, sum) in drinksByType {
                dataSet.append(PieChartDataEntry(value: sum, icon: UIImage(named: key)))
            }
        }
        let chartDataSet = PieChartDataSet(entries: dataSet, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: UIColor.Theme.aqua.cgColor), NSUIColor(cgColor: UIColor.Theme.sky.cgColor),NSUIColor(cgColor: UIColor.Theme.lavender.cgColor),NSUIColor(cgColor: UIColor.Theme.salmon.cgColor),NSUIColor(cgColor: UIColor.Theme.banana.cgColor)]
        chartDataSet.colors = colors
        chartDataSet.drawValuesEnabled = false
        chartDataSet.drawIconsEnabled = true
        self.pieChart.data = chartData
        
    }

}
