//
//  BioTableViewController.swift
//  RepHub
//
//  Created by Garrett Head on 9/21/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit
import HealthKit

class BioTableViewController: UITableViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var biologicalSexLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var bodyMassIndexTextField: UITextField!
    @IBOutlet weak var leanBodyMassTextField: UITextField!
    @IBOutlet weak var bodyFatPercentageTextField: UITextField!
    @IBOutlet weak var waistCircumferenceTextField: UITextField!
    
    private let healthDataKeys = ["firstName", "lastName", "biologicalSex", "dateOfBirth"]
    var datePicker:UIDatePicker!
    var biologicalSexOptions = ["N/A", "Male", "Female", "Other"]
    var heightOptions = [0,1,2,3,4,5,6,7,8,9,10,11]
    var dateOfBirthINT : Int?
    
    private var user : RepHubUser?

    private let userBodyMeasurements = UserBodyMeasurements()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sync", style: .plain, target: self, action: #selector(self.saveBio))
        self.fetchCurrentUser()
        self.setupGestures()
    }
    
    
    private func fetchCurrentUser(){
        self.getHKBodyMeasurements()
        API.RepHubUser.observerCurrentUser(completion: {
            user in
            self.user = user
            self.tableView.reloadData()
            self.updateView()
        })
    }

    private func clean(){
        self.dateOfBirthLabel.text = ""
        self.heightLabel.text = ""
        self.weightTextField.text = ""
        self.biologicalSexLabel.text = ""
        self.waistCircumferenceTextField.text = ""
        self.bodyMassIndexTextField.text = ""
        self.bodyFatPercentageTextField.text = ""
        self.leanBodyMassTextField.text = ""
        
    }
    
    private func updateView(){
        
        // User
        if let photoUrl = URL(string: user!.profileImageUrl!){
            self.imageView.sd_setImage(with: photoUrl, completed: nil)
        }
        
        if let firstName = user!.firstName {
            self.firstNameTextField.text = firstName
        }
        
        if let lastName = user!.lastName {
            self.lastNameTextField.text = lastName
        }
        
        if let biologicalSex = user!.biologicalSex {
            self.biologicalSexLabel.text = biologicalSex
        }
        
        if let dob = user!.dateOfBirth {
            self.dateOfBirthLabel.text = dob
        }
        
        // Body Measurements
        if let weight = userBodyMeasurements.weightInPounds {
            let weightFormatter = MassFormatter()
            weightFormatter.isForPersonMassUse = true
            self.weightTextField.placeholder = weightFormatter.string(fromValue: weight, unit: .pound)
        }
        
        if let height = userBodyMeasurements.heightInMeters {
            let heightFormatter = LengthFormatter()
            heightFormatter.isForPersonHeightUse = true
            heightLabel.text = heightFormatter.string(fromMeters: height)
        }
        
        if let bodyMassIndex = userBodyMeasurements.bodyMassIndex {
            bodyMassIndexTextField.placeholder = String(format: "%.02f", bodyMassIndex)
        }
        
        if let leanBodyMass = userBodyMeasurements.leanBodyMass {
            let weightFormatter = MassFormatter()
            weightFormatter.isForPersonMassUse = true
            self.leanBodyMassTextField.placeholder = weightFormatter.string(fromValue: leanBodyMass, unit: .pound)
        }
        
        if let bodyFatPercentage = userBodyMeasurements.bodyFatPercentage {
            self.bodyFatPercentageTextField.placeholder = String(format: "%.02f", bodyFatPercentage) + "%"
        }
        
        if let waistCircumference = userBodyMeasurements.waistCircumference {
            self.waistCircumferenceTextField.placeholder = String(format: "%.02f", waistCircumference) + "\""
        }
    }
    
    private func setupGestures(){
        let biologicalSexTap = UITapGestureRecognizer(target: self, action: #selector(tapBiologicalSex))
        biologicalSexLabel.isUserInteractionEnabled = true
        biologicalSexLabel.addGestureRecognizer(biologicalSexTap)

        let dateOfBirthTap = UITapGestureRecognizer(target: self, action: #selector(tapDateOfBirth))
        dateOfBirthLabel.isUserInteractionEnabled = true
        dateOfBirthLabel.addGestureRecognizer(dateOfBirthTap)
        
        let heightTap = UITapGestureRecognizer(target: self, action: #selector(tapHeight))
        heightLabel.isUserInteractionEnabled = true
        heightLabel.addGestureRecognizer(heightTap)
    }
    
    
    @objc func tapDateOfBirth() {
        let dateOfBirthAlert = UIAlertController(title: "Date of Birth", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let margin:CGFloat = 10.0

        datePicker = UIDatePicker(frame: CGRect(x: margin, y: 20, width: dateOfBirthAlert.view.bounds.size.width - margin * 4.0, height: 160))
        datePicker.datePickerMode = .date
        dateOfBirthAlert.view.addSubview(self.datePicker)
        dateOfBirthAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
            // Your actions here if "Done" clicked...
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: self.datePicker.date)
            print(dateString)
            let diffInDays = Calendar.current.dateComponents([.year], from: self.datePicker.date , to: Date()).year
            self.dateOfBirthLabel.text = "\(dateString) (\(String(describing: diffInDays!)))"
            self.dateOfBirthINT = Int(self.datePicker.date.timeIntervalSince1970)
        }))
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateOfBirthAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateOfBirthAlert.view.addConstraint(height)
        self.present(dateOfBirthAlert, animated: true, completion: nil)
    }
    
    @objc func tapBiologicalSex() {
        let bioSexChooserAlert = UIAlertController(title: "Biological Sex", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let margin:CGFloat = 10.0
        let picker = UIPickerView(frame: CGRect(x: margin, y: 20, width: bioSexChooserAlert.view.bounds.size.width - margin * 4.0, height: 160))
        
        picker.tag = 0;
        picker.delegate = self;
        picker.dataSource = self;

        bioSexChooserAlert.view.addSubview(picker)
        bioSexChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
            // Your actions here if "Done" clicked...
            self.biologicalSexLabel.text = self.biologicalSexOptions[picker.selectedRow(inComponent: 0)]
        }))
        let height: NSLayoutConstraint = NSLayoutConstraint(item: bioSexChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        bioSexChooserAlert.view.addConstraint(height)
        self.present(bioSexChooserAlert, animated: true, completion: nil)
    }
    
    @objc func tapHeight() {
        
        
        let heightChooserAlert = UIAlertController(title: "Set Height", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let margin:CGFloat = 10.0
        let picker = UIPickerView(frame: CGRect(x: margin, y: 20, width: heightChooserAlert.view.bounds.size.width - margin * 4.0, height: 160))
        
        picker.tag = 1;
        picker.delegate = self;
        picker.dataSource = self;
        
        heightChooserAlert.view.addSubview(picker)
        heightChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
            if picker.selectedRow(inComponent: 0) > 0 {
                let feet = self.heightOptions[picker.selectedRow(inComponent: 0)]
                let inches = self.heightOptions[picker.selectedRow(inComponent: 1)]
                self.heightLabel.text = "\(feet)\' \(inches)\""
            }
            
        }))
        let height: NSLayoutConstraint = NSLayoutConstraint(item: heightChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        heightChooserAlert.view.addConstraint(height)
        self.present(heightChooserAlert, animated: true, completion: nil)
    }
    
    
    @objc private func saveBio(){
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let bioSex = self.biologicalSexLabel.text!
        let dob = self.dateOfBirthLabel.text!
        API.RepHubUser.CURRENT_USER_REF?.updateChildValues(["firstName": firstName, "lastName": lastName, "biologicalSex" : bioSex, "dateOfBirth" : dob], withCompletionBlock: {
            (err, ref) in
            print("bio Saved! to Firebase")
            self.saveToHealthKit()
            self.clean()
            self.fetchCurrentUser()
        })
    }
    
    private func saveToHealthKit() {
        print("saving to HealthKit")
  
        if let height = self.heightLabel.text {
            let heightComponents = height.split(separator: " ")
            let feetStr = heightComponents[0]
            let inchStr = heightComponents[1]
            if let feet = Double(feetStr.prefix(upTo: feetStr.index(before: feetStr.endIndex))), let inch = Double(inchStr.prefix(upTo: inchStr.index(before: inchStr.endIndex))) {
                let heightInMeters = (feet + (inch/12))
                bodyMeasurementsDataStore.saveHeightSample(height: heightInMeters, date: Date())
                print("height saved to HealthKit.")
            }
        }
        
        if let weight = self.weightTextField.text, !weight.isEmpty {
            print("weight: \(weight)")
            let weightComponents = weight.split(separator: " ")
            let weigthStr = weightComponents[0]
            if let weightValue = Double(weigthStr) {
                bodyMeasurementsDataStore.saveWeightSample(weight: weightValue, date: Date())
                print("weight saved to HealthKit.")
            }
        } else {
            print("could not save weight.")
        }
        
        if let bodyFatPercentage = self.bodyFatPercentageTextField.text, !bodyFatPercentage.isEmpty {
            print("bodyFatPercentage: \(bodyFatPercentage)")
            let bodyFatPercentageComponents = bodyFatPercentage.split(separator: " ")
            let bodyFatPercentageStr = bodyFatPercentageComponents[0]
            if let bodyFatPercentageValue = Double(bodyFatPercentageStr) {
                bodyMeasurementsDataStore.saveBodyFatPercentageSample(bodyFatPercentage: bodyFatPercentageValue, date: Date())
                print("bodyFatPercentage saved to HealthKit.")
            }
            
        } else {
            print("could not save bodyFatPercentage.")
        }
        
        
        if let leanBodyMass = self.leanBodyMassTextField.text, !leanBodyMass.isEmpty {
            print("leanBodyMass: \(leanBodyMass)")
            let leanBodyMassComponents = leanBodyMass.split(separator: " ")
            let leanBodyMassStr = leanBodyMassComponents[0]
            if let leanBodyMassValue = Double(leanBodyMassStr) {
                bodyMeasurementsDataStore.saveLeanBodyMassSample(leanBodyMass: leanBodyMassValue, date: Date())
                print("leanBodyMass saved to HealthKit.")
            }
            
        } else {
            print("could not save leanBodyMass.")
        }
        
        if let waistCircumference = self.waistCircumferenceTextField.text, !waistCircumference.isEmpty {
            print("waistCircumference: \(waistCircumference)")
            let waistCircumferenceComponents = waistCircumference.split(separator: " ")
            let waistCircumferenceStr = waistCircumferenceComponents[0]
            if let waistCircumferenceValue = Double(waistCircumferenceStr) {
                bodyMeasurementsDataStore.saveWaistCircumferenceSample(waistCircumference: waistCircumferenceValue, date: Date())
                print("waistCircumference saved to HealthKit.")
            }
            
        } else {
            print("could not save waistCircumference.")
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 4
        default:
            return 6
        }
    }


}


// MARK : HealthKit associated methods
extension BioTableViewController {
    
    private func getHKBodyMeasurements(){
        
        // height
        if let heightSampleType = HKSampleType.quantityType(forIdentifier: .height){
            bodyMeasurementsDataStore.getMostRecentSample(for: heightSampleType) {
                (sample, error) in
                
                guard let sample = sample else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
                self.userBodyMeasurements.heightInMeters = heightInMeters
            }
        } else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
    
        // weight
        if let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) {
            bodyMeasurementsDataStore.getMostRecentSample(for: weightSampleType) {
                (sample, error) in
                guard let sample = sample else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                let weightInPounds = sample.quantity.doubleValue(for: HKUnit.pound())
                self.userBodyMeasurements.weightInPounds = weightInPounds
            }
        }
        else {
            print("Body Mass Sample Type is no longer available in HealthKit")
        }
        
        // body fat
        if let bodyFatSampleType = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage) {
            bodyMeasurementsDataStore.getMostRecentSample(for: bodyFatSampleType) {
                (sample, error) in
                guard let sample = sample else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
               
                let bodyFat = sample.quantity.doubleValue(for: HKUnit.percent())
                self.userBodyMeasurements.bodyFatPercentage = bodyFat
            }
        }
        else {
            print("Body Fat Sample Type is no longer available in HealthKit")
        }
        
        // bmi
        if let bmiSampleType = HKSampleType.quantityType(forIdentifier: .bodyMassIndex) {
            bodyMeasurementsDataStore.getMostRecentSample(for: bmiSampleType) {
                (sample, error) in
                guard let sample = sample else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                let bmi = sample.quantity.doubleValue(for: HKUnit.count())
                self.userBodyMeasurements.bodyFatPercentage = bmi
            }
        }
        else {
            print("Body Mass Index Sample Type is no longer available in HealthKit")
        }
        
        // lean body mass
        if let leanBodyMassSampleType = HKSampleType.quantityType(forIdentifier: .leanBodyMass) {
            bodyMeasurementsDataStore.getMostRecentSample(for: leanBodyMassSampleType) { (sample, error) in
                guard let sample = sample else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                let leanBodyMassInPounds = sample.quantity.doubleValue(for: HKUnit.pound())
                self.userBodyMeasurements.leanBodyMass = leanBodyMassInPounds
            }
        } else {
            print("leanBodyMass Sample Type is no longer available in HealthKit")
            return
        }
        
        // waist circumference
        if let waistCircumferenceSampleType = HKSampleType.quantityType(forIdentifier: .waistCircumference) {
            bodyMeasurementsDataStore.getMostRecentSample(for: waistCircumferenceSampleType) { (sample, error) in
                guard let sample = sample else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                let waistCircumference = sample.quantity.doubleValue(for: HKUnit.inch())
                self.userBodyMeasurements.waistCircumference = waistCircumference
            }
        } else {
            print("waistCircumference Sample Type is no longer available in HealthKit")
            return
        }
    }
    
}

extension BioTableViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 0:
            return 1
        default:
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return self.biologicalSexOptions.count
        case 1:
            return 12
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title : String
        switch pickerView.tag {
        case 0:
            title = self.biologicalSexOptions[row]
        case 1:
            if component == 0 {
                title = "\(row) ft"
            } else {
                title = "\(row) in"
            }
        default:
            title = ""
        }
        return title
        
    }
}
