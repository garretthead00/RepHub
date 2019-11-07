//
//  EnergyBalanceCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 10/5/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts


class EnergyBalanceCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var energyBalanceCombinedChart: CombinedChartView!

    
    var energyBurned : [(Date, Double, String)]? {
        didSet {
            self.updateView()
        }
    }
    var energyConsumed : [(Date, Double, String)]? {
        didSet {
            self.updateView()
        }
    }
    
    var energyBalance : [(Date, Double, String)]? {
        didSet {
            self.updateView()
        }
    }
    
    private func updateView(){
        self.setChartData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.setupChart()

    }
    
}

extension EnergyBalanceCollectionViewCell {
    
    private func setupChart(){

        self.energyBalanceCombinedChart.legend.enabled = false
        self.energyBalanceCombinedChart.chartDescription?.enabled = false
        self.energyBalanceCombinedChart.drawBarShadowEnabled = false
        self.energyBalanceCombinedChart.highlightFullBarEnabled = false
        self.energyBalanceCombinedChart.noDataText = "No data..."
        self.energyBalanceCombinedChart.animate(yAxisDuration: 1.25, easingOption: .easeInBounce)
        self.energyBalanceCombinedChart.xAxis.labelPosition = .bottom
        self.energyBalanceCombinedChart.xAxis.drawLabelsEnabled = true
        self.energyBalanceCombinedChart.xAxis.labelTextColor = UIColor.white
        self.energyBalanceCombinedChart.xAxis.labelCount = 6
        self.energyBalanceCombinedChart.drawOrder = [
            DrawOrder.bar.rawValue,
            DrawOrder.line.rawValue
        ]

    }
    
    private func setChartData() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        self.energyBalanceCombinedChart.xAxis.axisMaximum = data.xMax + 0.25
        self.energyBalanceCombinedChart.data = data
    }
    
    func generateLineData() -> LineChartData {

    
        if let energyBalance = self.energyBalance {
            let entries = (0..<energyBalance.count).map { (i) -> ChartDataEntry in
                return ChartDataEntry(x: Double(i) + 0.5, y: energyBalance[i].1)
            }
            
            let set = LineChartDataSet(entries: entries, label: "Line DataSet")
            set.setColor(UIColor.Theme.sky)
            set.lineWidth = 1.5
            set.setCircleColor(UIColor.Theme.sky)
            set.circleRadius = 2.5
            set.circleHoleRadius = 1.5
            set.fillColor = UIColor.Theme.sky
            set.mode = .cubicBezier
            set.drawValuesEnabled = true
            set.axisDependency = .left
            set.drawValuesEnabled = false
            return LineChartData(dataSet: set)
        }
         return LineChartData(dataSet: nil)

    }
    
    func generateBarData() -> BarChartData {
        
        if let energyConsumed = self.energyConsumed, let energyBurned = self.energyBurned, energyConsumed.count > 0, energyConsumed.count > 0 {
            let entries = (0..<energyConsumed.count).map { (i) -> BarChartDataEntry in
                return BarChartDataEntry(x: Double(i) + 0.5, yValues: [energyConsumed[i].1, energyBurned[i].1 * -1])
            }

            let set = BarChartDataSet(entries: entries, label: "")
            set.axisDependency = .left
            set.drawValuesEnabled = false
            set.stackLabels = ["Consumed", "Burned"]
            set.colors = [
                UIColor.Theme.Activity.eat,
                UIColor.Theme.Activity.exercise
            ]
            
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
