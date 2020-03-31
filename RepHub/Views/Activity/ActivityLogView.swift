//
//  ActivityLogView.swift
//  RepHub
//
//  Created by Garrett Head on 3/14/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit
import Charts
class ActivityLogView: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    
    var log : NutritionLog? {
        didSet{
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.text = ""
       // self.nameLabel.text = ""
        self.timestampLabel.text = ""
        self.servingLabel.text = ""
        self.energyLabel.text = ""
        self.icon.image = UIImage.Theme.Activity.eat
        self.layer.cornerRadius = 12.0
        self.layer.borderWidth = 0.0
        self.layer.masksToBounds = true
        
        
        self.pieChart.noDataText = ".."
        self.pieChart.legend.enabled = false
        self.pieChart.drawHoleEnabled = false
        self.pieChart.drawSlicesUnderHoleEnabled = true
        self.pieChart.usePercentValuesEnabled = false
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        
    }
    
}

extension ActivityLogView {
    
    private func updateView(){
        if let food = log!.food {
            if let category = food.category {
                if let image = UIImage(named: category) {
                    if let serving = log!.householdServingSize, let unit = log!.householdServingSizeUnit {
                        self.icon.image = image
                        self.title.text = category
                        //self.nameLabel.text = "\(food.name!)"
                        self.servingLabel.text = "\(Int(serving)) \(unit)"
                        self.energyLabel.text = "0.0 cals"
                        let dateString = self.log!.timestamp!.getDateString(format: "h:mm a")
                        self.timestampLabel.text = "\(dateString)"
                        
                        let protein = PieChartDataEntry(value: 30.0)
                        let fat = PieChartDataEntry(value: 24.0)
                        let carbs = PieChartDataEntry(value: 46.0)
                        let entries = calculateMacroPercent()
                        let chartDataSet = PieChartDataSet(entries: entries, label: nil)
                        let chartData = PieChartData(dataSet: chartDataSet)
                        chartDataSet.colors = [UIColor.Theme.salmon, UIColor.Theme.banana, UIColor.Theme.flora]
                        chartDataSet.sliceSpace = 0.8
                        chartDataSet.drawValuesEnabled = false
                        self.pieChart.data = chartData
                        chartDataSet.selectionShift = 0
                    }
                    
                }
            }
        }
    }
    
    private func calculateMacroPercent() -> [PieChartDataEntry]{
        var entries : [PieChartDataEntry] = []
        if let log = self.log {
            if let nutrition = log.nutrition {
                let protein = nutrition.filter{ $0.name == "Protein" }.first
                let fat = nutrition.filter{ $0.name == "Fat" }.first
                let carbs = nutrition.filter{ $0.name == "Carbohydrates" }.first
                entries = [PieChartDataEntry(value: protein!.value!),PieChartDataEntry(value: fat!.value!),PieChartDataEntry(value: carbs!.value!)]
            }
        }
        return entries
    }
}
