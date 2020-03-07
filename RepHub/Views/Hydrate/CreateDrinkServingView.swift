//
//  CreateDrinkServingView.swift
//  RepHub
//
//  Created by Garrett Head on 1/5/20.
//  Copyright © 2020 Garrett Head. All rights reserved.
//

import UIKit

class CreateDrinkServingView: UITableViewCell {
    @IBOutlet weak var servingSizeTextField: UITextField!
    @IBOutlet weak var unitPicker: UIPickerView!
    
    
    private var units = ["unit", "g", "mg", "oz", "fl oz", "ml"]
    var servingSize : Double?
    var selectedUnit : String?
    var delegate : CreateFoodDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.servingSizeTextField.text = ""
        self.unitPicker.delegate = self
        self.unitPicker.dataSource = self
        self.unitPicker.selectRow(0, inComponent: 0, animated: false)
        
        self.servingSizeTextField.addTarget(self, action: #selector(servingIsUpdating), for: .editingChanged)
    }
    @objc private func servingIsUpdating(){
        if let servingSize = self.servingSizeTextField.text {
            if let serving = Double(servingSize) {
                delegate?.updateServingSize(serving: serving)
            }
        }
    }
    
    private func updateView(){
        if let serving = self.servingSize, serving > 0 {
            if let unit = self.selectedUnit, let index = self.units.firstIndex(of: unit) {
                self.servingSizeTextField.text = "\(serving)"
                self.unitPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CreateDrinkServingView : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedUnit = self.units[row]
        if let unit = self.selectedUnit {
            delegate?.updateServingUnit(unit: unit)
        }
        self.updateView()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.units[row]
    }
    

}
