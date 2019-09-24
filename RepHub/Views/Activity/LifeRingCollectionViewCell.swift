//
//  LifeRingCollectionViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 9/16/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import Charts



protocol LifeRingDelegate {
    func segue(identifier: String)
}


class LifeRingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lifeDataLabel: UILabel!
    
    var delegate : LifeRingDelegate?

    
    var activityData : ActivityData?{
        didSet {
            self.updateView()
        }
    }
    
    var activity : Activity? {
        didSet {
            self.updateView()
        }
    }
    
    var percentComplete : Double?
    var percentRemaining : Double?
    var label : String?
    var icon : UIImage?
    var color : UIColor?
    
    override func awakeFromNib() {
        print("lifeRignAwake")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        self.iconImageView.isUserInteractionEnabled = true
        self.iconImageView.addGestureRecognizer(tapGestureRecognizer)
        self.setupCharts()
    }

    
    private func updateView(){
        
        print("activity!!! \(self.activity!.label!)")
        
        
        switch self.activity {
            case .mind(let mind):
                self.icon = mind.icon
                self.color = mind.color
                self.label = mind.label
            case .exercise(let exercise):
                self.icon = exercise.icon
                self.color = exercise.color
                self.label = exercise.label
            case .eat(let eat):
                self.icon = eat.icon
                self.color = eat.color
                self.label = eat.label
            case .hydrate(let hydrate):
                self.icon = hydrate.icon
                self.color = hydrate.color
                self.label = hydrate.label
            default:
                self.icon = nil
                self.color = nil
                self.label = ""
        }
        
        
        
        

        let pieChartDataEntry = PieChartDataEntry(value: self.activity!.percentComplete!, icon: nil, data: self.label!)
        let remainingPieChartDataEntry = PieChartDataEntry(value: self.activity!.percentRemaining!, icon: nil, data: self.label!)
        let colors = [self.color!,self.color!.withAlphaComponent(0.5)]
        let chartDataSet = PieChartDataSet(entries: [pieChartDataEntry,remainingPieChartDataEntry], label: nil)
        chartDataSet.sliceSpace = 4.0
        chartDataSet.xValuePosition = .insideSlice
        chartDataSet.yValuePosition = .insideSlice
        chartDataSet.drawValuesEnabled = false
        chartDataSet.useValueColorForLine = false
        chartDataSet.valueLineColor = UIColor.clear
        chartDataSet.valueLinePart1Length = -0.2
        chartDataSet.valueLinePart2Length = -0.1
        chartDataSet.colors = colors
        chartDataSet.selectionShift = 0
        let chartData = PieChartData(dataSet: chartDataSet)


        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "Damascus", size: 24.0)!,
            .foregroundColor: self.color!,
        ]
        let str = Int(self.activity!.percentComplete!)
        let myAttrString = NSAttributedString(string: "\(str)%", attributes: attributes)
        //self.pieChart.centerAttributedText = myAttrString
        self.lifeDataLabel.textColor = self.color!
        self.lifeDataLabel.text = "\(Int(self.activity!.percentComplete!))%"
        self.iconImageView.image = self.icon!
        self.pieChart.data = chartData
        
    }
    
    @objc func iconTapped(){
        delegate?.segue(identifier: self.label!)
    }
    
    

    
}

// MARK: - Charts
extension LifeRingCollectionViewCell {
    
    private func setupCharts(){
        self.pieChart.noDataText = "There's no data today..."
        self.pieChart.legend.enabled = false
        self.pieChart.drawHoleEnabled = true
        self.pieChart.holeColor = NSUIColor.black
        self.pieChart.drawSlicesUnderHoleEnabled = true
        self.pieChart.usePercentValuesEnabled = true
        self.pieChart.holeRadiusPercent = 0.9
        self.pieChart.animate(xAxisDuration: 1.25, yAxisDuration: 1.25)
        self.pieChart.delegate = self
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
    }

}

extension LifeRingCollectionViewCell : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        delegate?.segue(identifier: self.label!)
    }
}


