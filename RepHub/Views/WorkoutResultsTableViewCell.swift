//
//  WorkoutResultsTableViewCell.swift
//  
//
//  Created by Garrett Head on 5/28/19.
//

import UIKit

class WorkoutResultsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var logDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var totalReps : Int?
    var totalWork : Double?
    var totalSteps : Int?
    var caloriesBurned : Double?
    var totalDistance : Double?
    var workoutDurationSeconds : Double?
    var durationString : String?
    var score : Int? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.caloriesLabel.text = ""
        self.distanceLabel.text = ""
        self.repsLabel.text = ""
        self.stepsLabel.text = ""
        self.durationLabel.text = ""
        self.scoreLabel.text = ""
        self.scoreLabel.layer.borderColor = UIColor.darkGray.cgColor
        self.scoreLabel.layer.borderWidth = 1.0;
        self.scoreLabel.layer.cornerRadius = 12
        
    }
    

    private func updateView(){
        self.caloriesLabel.text = String(format: "%.2f", self.caloriesBurned!) + " kCals"
        self.distanceLabel.text = String(format: "%.2f", self.totalDistance!) + " mi"
        self.repsLabel.text = "\(self.totalReps!) reps"
        self.stepsLabel.text = "\(self.totalSteps!) steps"
        self.durationLabel.text = self.durationString!
        self.scoreLabel.text = "\(self.score!)%"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
