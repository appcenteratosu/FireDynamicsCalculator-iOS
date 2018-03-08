//
//  ThermallyThinView.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/7/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class ThermallyThinView: UIView, PickerResponderDelegate, UITextFieldDelegate, ToolbarHandlerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // Setup
    func configure() {
        setupButton()
        setupTextFields()
        setupToolbar()
    }
    
    private func setupButton() {
        self.densityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.thicknessButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.ignitionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.ambientButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.heatFluxButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    }
    
    
    @IBOutlet weak var toolbar: ToolbarHandler!
    func endEditing() {
        self.endEditing(true)
    }
    
    func setupToolbar() {
        toolbar.tbDelegate = self
    }
    
    private func setupTextFields() {
        self.densityTF.inputAccessoryView = toolbar
        self.specificHeatTF.inputAccessoryView = toolbar
        self.thicknessTF.inputAccessoryView = toolbar
        self.ignitionTempTF.inputAccessoryView = toolbar
        self.ambientTempTF.inputAccessoryView = toolbar
        self.heatFluxTF.inputAccessoryView = toolbar
    }
    
    // Delegate
    
    var pickerDelegate: PickerDelegate?
    
    
    // Outlets
    
    @IBOutlet weak var densityTF: UITextField!
    @IBOutlet weak var specificHeatTF: UITextField!
    @IBOutlet weak var thicknessTF: UITextField!
    @IBOutlet weak var ignitionTempTF: UITextField!
    @IBOutlet weak var ambientTempTF: UITextField!
    @IBOutlet weak var heatFluxTF: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == densityTF {
            specificHeatTF.becomeFirstResponder()
        } else if textField == specificHeatTF {
            thicknessTF.becomeFirstResponder()
        } else if textField == thicknessTF {
            ignitionTempTF.becomeFirstResponder()
        } else if textField == ignitionTempTF {
            ambientTempTF.becomeFirstResponder()
        } else if textField == ambientTempTF {
            heatFluxTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBOutlet weak var densityButton: UIButton!
    @IBOutlet weak var thicknessButton: UIButton!
    @IBOutlet weak var ignitionButton: UIButton!
    @IBOutlet weak var ambientButton: UIButton!
    @IBOutlet weak var heatFluxButton: UIButton!
    @IBOutlet weak var ttiButton: RoundedButton!
    
    @IBOutlet weak var timeToIgnitionLabel: UILabel!
    
    // Change Units
    var buttonForEditing: UIButton?
    
    @IBAction func changeDensityUnits(_ sender: Any) {
        buttonForEditing = densityButton
        pickerDelegate?.setDataSource(dataSet: .Density)
    }
    
    @IBAction func changeThicknessUnits(_ sender: Any) {
        buttonForEditing = thicknessButton
        pickerDelegate?.setDataSource(dataSet: .Length)
    }
    
    @IBAction func changeIgnitionTempUnits(_ sender: Any) {
        buttonForEditing = ignitionButton
        pickerDelegate?.setDataSource(dataSet: .Temperature)
    }
    
    @IBAction func changeAmbientTempUnits(_ sender: Any) {
        buttonForEditing = ambientButton
        pickerDelegate?.setDataSource(dataSet: .Temperature)
    }
    
    @IBAction func changeHeatFluxUnits(_ sender: Any) {
        buttonForEditing = heatFluxButton
        pickerDelegate?.setDataSource(dataSet: .EneregyDensity)
    }
    
    @IBAction func changeTTIUnits(_ sender: Any) {
        buttonForEditing = ttiButton
        pickerDelegate?.setDataSource(dataSet: .Time)
    }
    
    func didSelectOption(option: String) {
        buttonForEditing?.setTitle(option, for: .normal)
    }
    
    // Calculate
    
    @IBAction func calculate(_ sender: Any) {
        let calc = SolidIgnitionCalculator()
        let result = calc.thermallyThin(density: densityTF.text!,
                           densityUnits: densityButton.titleLabel!.text!,
                           specificHeat: specificHeatTF.text!,
                           thickness: thicknessTF.text!,
                           thicknessUnits: thicknessButton.titleLabel!.text!,
                           TIG: ignitionTempTF.text!,
                           TIGUnits: ignitionButton.titleLabel!.text!,
                           TAMB: ambientTempTF.text!,
                           TAMBUnits: ambientButton.titleLabel!.text!,
                           heatFlux: heatFluxTF.text!,
                           heatFluxUnits: heatFluxButton.titleLabel!.text!,
                           ttiUnits: ttiButton.titleLabel!.text!)
        
        self.timeToIgnitionLabel.text = "\(result)"
        
    }
    
    

}


protocol PickerDelegate {
    func setDataSource(dataSet: Conversion.Units.List)
}

