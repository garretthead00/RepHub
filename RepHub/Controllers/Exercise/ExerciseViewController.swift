//
//  ExerciseViewController.swift
//  RepHub
//
//  Created by Garrett Head on 8/10/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var musclegroupLabel: UILabel!
    @IBOutlet weak var forceLabel: UILabel!
    @IBOutlet weak var modalityLabel: UILabel!
    @IBOutlet weak var jointLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    var exerciseId : String!
    var exercise : Exercise!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadExercise()
    }

    private func loadExercise(){
        API.Exercise.observeExercise(withId: exerciseId, completion: {
            exercise in
            self.exercise = exercise
            self.updateView()
        })
    }
    private func updateView(){
        self.nameLabel.text = self.exercise?.name
        self.musclegroupLabel.text = self.exercise?.muscleGroup
        self.forceLabel.text = self.exercise?.force
        self.modalityLabel.text = self.exercise?.modality
        self.jointLabel.text = self.exercise?.joint
        self.regionLabel.text = self.exercise?.region
        self.sectionLabel.text = self.exercise?.section
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
