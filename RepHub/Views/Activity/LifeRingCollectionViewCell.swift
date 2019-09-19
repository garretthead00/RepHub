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
    var lifeData : LifeData?{
        didSet {
            self.updateView()
        }
    }
    
    override func awakeFromNib() {
        print("lifeRignAwake")
        self.setupCharts()
    }
    
    private func updateView(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        self.iconImageView.isUserInteractionEnabled = true
        self.iconImageView.addGestureRecognizer(tapGestureRecognizer)
        
        print("printing life ring")
        let remaining = 100.0 - self.lifeData!.percentCompleted!
        let pieChartDataEntry = PieChartDataEntry(value: self.lifeData!.percentCompleted!, icon: nil, data: self.lifeData?.data)
        let remainingPieChartDataEntry = PieChartDataEntry(value: remaining, icon: nil, data: self.lifeData?.data)
        let thisColor = self.lifeData!.color
        let colors = [thisColor,thisColor!.withAlphaComponent(0.5)]
        let chartDataSet = PieChartDataSet(entries: [pieChartDataEntry,remainingPieChartDataEntry], label: nil)
        chartDataSet.sliceSpace = 4.0
        chartDataSet.xValuePosition = .insideSlice
        chartDataSet.yValuePosition = .insideSlice
        chartDataSet.drawValuesEnabled = false
        chartDataSet.useValueColorForLine = false
//        chartDataSet.valueLineColor = UIColor.clear
//        chartDataSet.valueLinePart1Length = -0.2
//        chartDataSet.valueLinePart2Length = -0.1
        //chartDataSet.valueFont = UIFont.boldSystemFont(ofSize: 18.0)
        //chartDataSet.valueColors = [UIColor.Theme.salmon]
        chartDataSet.colors = colors as! [NSUIColor]
        chartDataSet.selectionShift = 0
        let chartData = PieChartData(dataSet: chartDataSet)
        
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.init(name: "Damascus", size: 24.0)!,
            .foregroundColor: self.lifeData!.color!,
        ]
        let str = Int(self.lifeData!.percentCompleted!)
        let myAttrString = NSAttributedString(string: "\(str)%", attributes: attributes)
        //self.pieChart.centerAttributedText = myAttrString
        self.lifeDataLabel.textColor = self.lifeData?.color
        self.lifeDataLabel.text = "\(Int(self.lifeData!.percentCompleted!))%"
        self.iconImageView.image = self.lifeData?.icon
        self.pieChart.data = chartData
        
    }
    
    @objc func iconTapped(){
        guard let lifeType = self.lifeData?.data else {
            return
        }
        delegate?.segue(identifier: lifeType.rawValue)
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
        //self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
    }

}

extension LifeRingCollectionViewCell : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let lifeType = entry.data as? LifeTypes else {
            return
        }
        delegate?.segue(identifier: lifeType.rawValue)
    }
}


