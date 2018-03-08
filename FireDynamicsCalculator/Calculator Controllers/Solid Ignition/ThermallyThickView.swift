//
//  ThermallyThickView.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/8/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class ThermallyThickView: UIView, PickerResponderDelegate, UITextFieldDelegate, ToolbarHandlerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - Setup
    func configure() {
        setupButtons()
        setupTextFields()
        setupToolbar()
    }
    
    private func setupButtons() {
        self.densityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.ignitionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.ambientButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.heatFluxButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        self.ttiButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    }
    
    private func setupTextFields() {
        self.densityTF.inputAccessoryView = toolbar
        self.cTF.inputAccessoryView = toolbar
        self.specificHeatTF.inputAccessoryView = toolbar
        self.ThermalConductivityTF.inputAccessoryView = toolbar
        self.ignitionTempTF.inputAccessoryView = toolbar
        self.ambientTempTF.inputAccessoryView = toolbar
        self.heatFluxTF.inputAccessoryView = toolbar
    }
    
    func setupToolbar() {
        toolbar.tbDelegate = self
    }
    
    //toolbar
    @IBOutlet weak var toolbar: ToolbarHandler!
    func endEditing() {
        self.endEditing(true)
    }
    
    
    // MARK: - Delegate
    var pickerDelegate: PickerDelegate?
    
    
    // MARK: - Outlets
    @IBOutlet weak var densityTF: UITextField!
    @IBOutlet weak var cTF: UITextField!
    @IBOutlet weak var specificHeatTF: UITextField!
    @IBOutlet weak var ThermalConductivityTF: UITextField!
    @IBOutlet weak var ignitionTempTF: UITextField!
    @IBOutlet weak var ambientTempTF: UITextField!
    @IBOutlet weak var heatFluxTF: UITextField!
    
    @IBOutlet weak var densityButton: UIButton!
    @IBOutlet weak var ignitionButton: UIButton!
    @IBOutlet weak var ambientButton: UIButton!
    @IBOutlet weak var heatFluxButton: UIButton!
    @IBOutlet weak var ttiButton: RoundedButton!
    
    @IBOutlet weak var timeToIgnitionLabel: UILabel!
    
    var buttonForEditing: UIButton?
    @IBAction func changeDensityUnits(_ sender: Any) {
        buttonForEditing = densityButton
        pickerDelegate?.setDataSource(dataSet: .Density)
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
    
    
    // MARK: - Calculation
    
    @IBAction func calculate(_ sender: Any) {
        let calc = SolidIgnitionCalculator()
        let result = calc.thermallyThick(c: cTF.text!,
                                         density: densityTF.text!, densityUnits: densityButton.titleLabel!.text!,
                                         specificHeat: specificHeatTF.text!,
                                         thermalConductivity: ThermalConductivityTF.text!,
                                         TIG: ignitionTempTF.text!, TIGUnits: ignitionButton.titleLabel!.text!,
                                         TAMB: ambientTempTF.text!, TAMBUnits: ambientButton.titleLabel!.text!,
                                         heatFlux: heatFluxTF.text!, heatFluxUnits: heatFluxButton.titleLabel!.text!,
                                         ttiUnits: ttiButton.titleLabel!.text!)
        
        self.timeToIgnitionLabel.text = "\(result)"
        
    }
    
    
    func didSelectOption(option: String) {
        buttonForEditing?.setTitle(option, for: .normal)
    }

}
