//
//  HydrateStatusTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 6/13/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts

class HydrateStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var targetButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var pieChart: PieChartView!
    

    var date : String?
    var total : Double?
    var remaining : Double?
    var alarmOn : Bool?
    var score : Int? {
        didSet{
            self.updateView()
        }
    }
    var totalDataEntry = PieChartDataEntry(value: 0.0)
    var remainingDataEntry = PieChartDataEntry(value: 0.0)
    var dataSet = [PieChartDataEntry]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateLabel.text = ""
        self.pieChart.chartDescription?.text = "Target"
        self.pieChart.noDataText = "Drink up...There's no data today."
        self.pieChart.holeColor = UIColor.black
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.Theme.aqua,
            .font: UIFont.systemFont(ofSize: 36)
        ]
        let firstString = NSMutableAttributedString(string: "", attributes: firstAttributes)
        self.pieChart.centerAttributedText = firstString
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        totalDataEntry.label = "oz"
        remainingDataEntry.label = "oz"
        dataSet = [totalDataEntry, remainingDataEntry]

    }
    
    private func updateView() {
        self.dateLabel.text = self.date
        if let alarmOn = self.alarmOn, alarmOn {
            self.reminderButton.setImage(UIImage(named: "alarmOn"), for: .normal)
        } else {
            self.reminderButton.setImage(UIImage(named: "alarmOff"), for: .normal)
        }
        totalDataEntry.value = self.total!
        remainingDataEntry.value = self.remaining!
        
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.Theme.aqua,
            .font: UIFont.systemFont(ofSize: 36)
        ]
        let firstString = NSMutableAttributedString(string: "\(self.score!) %", attributes: firstAttributes)
        self.pieChart.centerAttributedText = firstString
        updateChartData()
        
    }
    
    private func updateChartData() {
        
        let chartDataSet = PieChartDataSet(entries: dataSet, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSUIColor(cgColor: UIColor.Theme.aqua.cgColor), NSUIColor(cgColor: UIColor.Theme.sky.cgColor)]
        chartDataSet.colors = colors
        self.pieChart.data = chartData
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
