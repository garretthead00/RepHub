//
//  ActivitySummaryView.swift
//  RepHub
//
//  Created by Garrett Head on 1/25/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit



class ActivitySummaryView: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var daysOfTheWeek = ["Sun", "Mon","Tue","Wed","Thu","Fri","Sat"]
    var monthsOfTheYear = ["Jan","Feb","Mar","Apr","Jun","Jul","Aug","Sept","Nov","Dec"]
    
    var weatherCondition : String? {
        didSet {
            self.updateView()
        }
    }
    var date : Date? {
        didSet {
            self.updateView()
        }
    }
    var temperature : String? {
        didSet {
            self.updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayLabel.text = ""
        self.dateLabel.text = ""
        self.yearLabel.text = ""
        self.temperatureLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func updateView(){
        if let date = self.date {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents(
                [.calendar, .timeZone, .year, .month, .day, .weekday, .weekdayOrdinal],
                from: date)
            if let weekday = dateComponents.weekday, let month = dateComponents.month, let day = dateComponents.day, let year = dateComponents.year {
                self.dayLabel.text = "\(self.daysOfTheWeek[weekday-1])"
                self.dateLabel.text = "\(self.monthsOfTheYear[month-1]) \(day)"
                self.yearLabel.text = "\(year)"
            }
            

        }
        if let temperature = self.temperature {
            self.temperatureLabel.text = temperature
        }
        if let weatherCondition = self.weatherCondition {
            //self.weatherImage.image = UIImage(named: weatherCondition)
        }
    }

}
