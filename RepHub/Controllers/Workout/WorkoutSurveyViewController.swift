//
//  WorkoutSurveyViewController.swift
//  RepHub
//
//  Created by Garrett Head on 12/14/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class WorkoutSurveyViewController: UIViewController {

    @IBOutlet weak var StarButton_1: UIButton!
    @IBOutlet weak var StarButton_2: UIButton!
    @IBOutlet weak var StarButton_3: UIButton!
    @IBOutlet weak var StarButton_4: UIButton!
    @IBOutlet weak var StarButton_5: UIButton!
    @IBOutlet weak var SuccessTextField: UITextField!
    @IBOutlet weak var FailTextField: UITextField!
    @IBOutlet weak var CommentTextView: UITextView!
    private var starRating = 0
    var workoutId : String?
    var workoutLogId : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Star Button Targets
        self.StarButton_1.addTarget(self, action: #selector(oneStarRating), for: .touchUpInside)
        self.StarButton_2.addTarget(self, action: #selector(twoStarRating), for: .touchUpInside)
        self.StarButton_3.addTarget(self, action: #selector(threeStarRating), for: .touchUpInside)
        self.StarButton_4.addTarget(self, action: #selector(fourStarRating), for: .touchUpInside)
        self.StarButton_5.addTarget(self, action: #selector(fiveStarRating), for: .touchUpInside)
        
        // CommentTextView
        let borderColor : UIColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)
        CommentTextView!.layer.borderWidth = 0.5
        CommentTextView!.layer.borderColor = borderColor.cgColor
        CommentTextView!.layer.cornerRadius = 5.0
        
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: Star Rating Actions
    private func clearStars(){
        self.StarButton_1.setImage(UIImage(named: "star_green.png"), for: .normal)
        self.StarButton_2.setImage(UIImage(named: "star_green.png"), for: .normal)
        self.StarButton_3.setImage(UIImage(named: "star_green.png"), for: .normal)
        self.StarButton_4.setImage(UIImage(named: "star_green.png"), for: .normal)
        self.StarButton_5.setImage(UIImage(named: "star_green.png"), for: .normal)
        self.starRating = 0
    }
    
    @objc private func oneStarRating(){
        print("one star review")
        self.clearStars()
        self.StarButton_1.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.starRating = 1
    }
    
    @objc private func twoStarRating(){
        print("two star review")
        self.clearStars()
        self.StarButton_1.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_2.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.starRating = 2

    }
    
    @objc private func threeStarRating(){
        print("three star review")
        self.clearStars()
        self.StarButton_1.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_2.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_3.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.starRating = 3
    }
    
    @objc private func fourStarRating(){
        print("four star review")
        self.clearStars()
        self.StarButton_1.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_2.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_3.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_4.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.starRating = 4

    }
    
    @objc private func fiveStarRating(){
        print("five star review")
        self.clearStars()
        self.StarButton_1.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_2.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_3.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_4.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.StarButton_5.setImage(UIImage(named: "star_filled_green.png"), for: .normal)
        self.starRating = 5
    }
    
    @IBAction func SaveSurvey_TouchUpInside(_ sender: Any) {
        print("-----WORKOUT SURVEY-----")
        print("Star Rating: \(self.starRating)")
        if let successComment = self.SuccessTextField.text {
             print("Success: \(successComment)")
        }
        if let failedComment = self.FailTextField.text {
            print("failed: \(failedComment)")
        }
        if let comment = self.CommentTextView.text {
            print("Comment: \(comment)")
        }
        
        guard let currentUser = API.RepHubUser.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        let successComment = self.SuccessTextField.text
        let failedComment = self.FailTextField.text
        let comment = self.CommentTextView.text
        let timestamp = Int(Date().timeIntervalSince1970)
        let newSurveyEntryRef = API.WourkoutJournal.WORKOUTJOURNAL_DB_REF.childByAutoId()
        newSurveyEntryRef.setValue(["workoutLog": self.workoutLogId, "starRating": self.starRating, "successComment": successComment, "failedComment": failedComment, "comment": comment, "timeStamp" : timestamp], withCompletionBlock: {
            error, ref in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            API.UserJournalEntries.USER_JOURNAL_ENTRIES_DB_REF.child(currentUserId).child(newSurveyEntryRef.key).setValue(true, withCompletionBlock: {
                error, ref in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                ProgressHUD.showSuccess("Journal Entry saved!")
                let thisVC = self.presentingViewController
                self.dismiss(animated: false) {
                    thisVC?.dismiss(animated: false, completion: nil)
                }
            })
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
