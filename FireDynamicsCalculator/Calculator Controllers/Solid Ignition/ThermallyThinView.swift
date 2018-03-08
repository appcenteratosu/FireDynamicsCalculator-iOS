//
//  ThermallyThinView.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/7/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class ThermallyThinView: UIView, PickerResponderDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // Delegate
    
    var pickerDelegate: PickerDelegate?
    
    
    // Outlets
    
    @IBOutlet weak var densityTF: UITextField!
    @IBOutlet weak var specificHeatTF: UITextField!
    @IBOutlet weak var thicknessTF: UITextField!
    @IBOutlet weak var ignitionTempTF: UITextField!
    @IBOutlet weak var ambientTempTF: UITextField!
    @IBOutlet weak var heatFluxTF: UITextField!
    
    @IBOutlet weak var densityButton: UIButton!
    @IBOutlet weak var thicknessButton: UIButton!
    @IBOutlet weak var ignitionButton: UIButton!
    @IBOutlet weak var ambientButton: UIButton!
    @IBOutlet weak var heatFluxButton: UIButton!
    
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
    
    func didSelectOption(option: String) {
        buttonForEditing?.setTitle(option, for: .normal)
    }
    
    // Calculate
    
    @IBAction func calculate(_ sender: Any) {
        
    }
    
    
    

}


protocol PickerDelegate {
    func setDataSource(dataSet: Conversion.Units.List)
}

