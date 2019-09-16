//
//  EatMacrosTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 8/22/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class EatMacrosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var macrosPieChart: PieChartView!
    var proteinDataEntry : PieChartDataEntry?
    var fatsDataEntry : PieChartDataEntry?
    var carbsDataEntry : PieChartDataEntry?
    var dataSet = [PieChartDataEntry]()
    var macrosSet : [String:Double]? {
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.macrosPieChart.chartDescription?.text = "Macros"
        self.macrosPieChart.noDataText = "Eat up...There's no data today."
        self.macrosPieChart.drawHoleEnabled = false
        self.macrosPieChart.legend.enabled = false
        self.macrosPieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView() {
        self.proteinDataEntry = PieChartDataEntry(value: self.macrosSet!["protein"]!)
        self.fatsDataEntry = PieChartDataEntry(value: self.macrosSet!["fats"]!)
        self.carbsDataEntry = PieChartDataEntry(value: self.macrosSet!["carbs"]!)
        self.proteinDataEntry!.label = "Protein"
        self.fatsDataEntry!.label = "Fats"
        self.carbsDataEntry!.label = "Carbs"
        dataSet = [self.proteinDataEntry, self.fatsDataEntry, self.carbsDataEntry] as! [PieChartDataEntry]
        
        
        let chartDataSet = PieChartDataSet(entries: dataSet, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: UIColor.Theme.salmon.cgColor), NSUIColor(cgColor: UIColor.Theme.sky.cgColor), NSUIColor(cgColor: UIColor.Theme.seaFoam.cgColor)]
        chartDataSet.colors = colors
        self.macrosPieChart.data = chartData
    }

}
