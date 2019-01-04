//
//  JournalEntryTableViewCell.swift
//  RepHub
//
//  Created by Garrett Head on 12/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class JournalEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var successCommentLabel: UILabel!
    @IBOutlet weak var failedCommentLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    var workoutLog : WorkoutLog?
    var workoutName : String?
    var journalEntry : JournalEntry? {
        didSet {
            self.updateView()
        }
    }
    
    
    private func updateView(){
        
        if let timestamp = self.journalEntry?.timestamp {
            self.dateLabel.text = "\(timestamp)"
        }
        if let rating = self.journalEntry?.starRating {
            self.ratingLabel.text = "\(rating)"
        }
        if let success = self.journalEntry?.successComment {
            self.successCommentLabel.text = success
        }
        if let failed = self.journalEntry?.failedComment {
            self.failedCommentLabel.text = failed
        }
        if let comment = self.journalEntry?.comment {
            self.commentTextView.text = comment
        }
        if let name = self.workoutName {
            self.workoutNameLabel.text = name
        }
        if let reps = self.workoutLog?.totalReps {
            self.repsLabel.text = "\(reps) reps"
        }
        if let work = self.workoutLog?.totalWork {
            self.workLabel.text = "\(work) lbs"
        }
        if let calories = self.workoutLog?.totalCalories {
            self.caloriesLabel.text = "\(calories) kCals"
        }
        if let distance = self.workoutLog?.totalDistance {
            self.distanceLabel.text = "\(distance) mi"
        }
        if let duration = self.workoutLog?.duration {
            self.durationLabel.text = "\(duration) min"
        }
        if let steps = self.workoutLog?.totalSteps {
            self.stepsLabel.text = "\(steps) steps"
        }
        
    }


}
