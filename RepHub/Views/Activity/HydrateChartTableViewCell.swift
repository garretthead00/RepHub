//
//  HydrateChartTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 11/8/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class HydrateChartTableViewCell: UITableViewCell {

    @IBOutlet weak var pieChart: PieChartView!
    
    var activity : Activity? {
        didSet {
            self.setChartData()
        }
    }
    
    var drinksByType : [String:Double]? {
        didSet {
            self.setChartData()
        }
    }
    
    // Calculation Items
    var total : Double?
    var remaining : Double?
    var score : Int? {
        didSet{
            self.updateView()
        }
    }

    
    // Chart Items
    var totalDataEntry = PieChartDataEntry(value: 0.0)
    var remainingDataEntry = PieChartDataEntry(value: 0.0)
    var dataSet : [PieChartDataEntry]? {
        didSet{
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pieChart.legend.enabled = false
        self.pieChart.drawHoleEnabled = true
        self.pieChart.drawSlicesUnderHoleEnabled = true
        self.pieChart.usePercentValuesEnabled = true
        self.pieChart.chartDescription?.text = "Target"
        self.pieChart.noDataText = "Drink up...There's no data today."
        self.pieChart.holeColor = UIColor.black
        self.pieChart.holeRadiusPercent = 0.8
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
    
    private func updateView(){
        totalDataEntry.value = self.total ?? 0
        remainingDataEntry.value = self.remaining ?? 0
        
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.Theme.aqua,
            .font: UIFont.systemFont(ofSize: 36)
        ]
        let firstString = NSMutableAttributedString(string: "\(self.score ?? 0) %", attributes: firstAttributes)
        self.pieChart.centerAttributedText = firstString
        updateChartData()
    }
    
    
    private func setChartData() {
        if let activity = self.activity {
            let percentComplete = PieChartDataEntry(value: activity.percentComplete ?? 0)
            let percentremaining = PieChartDataEntry(value: activity.percentRemaining ?? 0)
//            percentComplete.label = "%"
//            percentremaining.label = "%"
            self.dataSet = [percentComplete, percentremaining]
        }
        
        if let drinksByType = self.drinksByType {
            self.dataSet = []
            for (key, sum) in drinksByType {
                print("key: \(key) ---sum: \(sum)")
                self.dataSet?.append(PieChartDataEntry(value: sum))
                
                
            }
        }
        
        
        

    }
    
    private func updateChartData() {
        
        let chartDataSet = PieChartDataSet(entries: self.dataSet, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: UIColor.Theme.aqua.cgColor), NSUIColor(cgColor: UIColor.Theme.sky.cgColor)]
        chartDataSet.colors = colors
        chartDataSet.drawValuesEnabled = false
        self.pieChart.data = chartData
    }

}
