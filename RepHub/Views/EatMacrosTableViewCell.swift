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
    var proteinDataEntry = PieChartDataEntry(value: 36.0)
    var fatsDataEntry = PieChartDataEntry(value: 24.0)
    var carbsDataEntry = PieChartDataEntry(value: 40.0)
    var dataSet = [PieChartDataEntry]()
    
    var title : String? {
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
        self.proteinDataEntry.label = "Protein"
        self.fatsDataEntry.label = "Fats"
        self.carbsDataEntry.label = "Carbs"
        dataSet = [proteinDataEntry, fatsDataEntry,carbsDataEntry]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateView() {
        //totalDataEntry.label = title
        let chartDataSet = PieChartDataSet(entries: dataSet, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: UIColor.Theme.salmon.cgColor), NSUIColor(cgColor: UIColor.Theme.sky.cgColor), NSUIColor(cgColor: UIColor.Theme.seaFoam.cgColor)]
        chartDataSet.colors = colors
        self.macrosPieChart.data = chartData
    }

}
