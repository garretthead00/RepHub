//
//  MacroChartView.swift
//  RepHub
//
//  Created by Garrett Head on 1/12/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts


class MacroChartView: UITableViewCell {

    @IBOutlet weak var pieChart: PieChartView!
    
    var protein : Double? {
        didSet {
            self.updateView()
        }
    }
    var fats : Double? {
        didSet {
            self.updateView()
        }
    }
    var carbs : Double? {
        didSet {
            self.updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pieChart.legend.enabled = false
        self.pieChart.chartDescription?.enabled = false
        self.pieChart.noDataText = "Eat up...There's no data today."
        self.pieChart.drawHoleEnabled = false
        //self.pieChart.holeColor = UIColor.black
//        let firstAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.Theme.Activity.eat,
//            .font: UIFont.systemFont(ofSize: 24)
//        ]
//        let firstString = NSMutableAttributedString(string: "", attributes: firstAttributes)
//        self.pieChart.centerAttributedText = firstString
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView(){
        var dataSet = [PieChartDataEntry]()
        if let protiein = self.protein {
            let proteinEntry = PieChartDataEntry(value: protiein)
            proteinEntry.label = "Protein"
            dataSet.append(proteinEntry)
        }
        if let fats = self.fats {
            let fatEntry = PieChartDataEntry(value: fats)
            fatEntry.label = "Fats"
            dataSet.append(fatEntry)
        }
        if let carbs = self.carbs {
            let carbsEntry = PieChartDataEntry(value: carbs)
            carbsEntry.label = "Carbs"
            dataSet.append(carbsEntry)
        }
        let chartDataSet = PieChartDataSet(entries: dataSet, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: UIColor.Theme.salmon.cgColor), NSUIColor(cgColor: UIColor.Theme.banana.cgColor),NSUIColor(cgColor: UIColor.Theme.sky.cgColor)]
        chartDataSet.colors = colors
        self.pieChart.data = chartData
    }

}
