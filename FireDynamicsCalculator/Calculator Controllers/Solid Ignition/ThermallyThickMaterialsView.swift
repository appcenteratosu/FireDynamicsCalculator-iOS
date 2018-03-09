//
//  ThermallyThickMaterialsView.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/8/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class ThermallyThickMaterialsView: UIView, PickerResponderDelegate, ToolbarHandlerDelegate {

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
        setupTextfields()
        setupToolbar()
    }
    
    func setupButtons() {
        materialButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        tambButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        heatFluxButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    }
    
    func setupTextfields() {
        specificHeatTF.inputAccessoryView = toolbar
        tambTF.inputAccessoryView = toolbar
        heatFluxTF.inputAccessoryView = toolbar
    }
    
    func setupToolbar() {
        toolbar.tbDelegate = self
    }
    
    // MARK: - Toolbar
    @IBOutlet weak var toolbar: ToolbarHandler!
    func endEditing() {
        self.endEditing(true)
    }
    
    // MARK: - Delegate
    var pickerDelegate: PickerDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var ttiLabel: UILabel!
    
    @IBOutlet weak var materialButton: RoundedButton!
    @IBOutlet weak var tambButton: RoundedButton!
    @IBOutlet weak var heatFluxButton: RoundedButton!
    @IBOutlet weak var ttiButton: RoundedButton!
    
    @IBOutlet weak var specificHeatTF: UITextField!
    @IBOutlet weak var tambTF: UITextField!
    @IBOutlet weak var heatFluxTF: UITextField!
    
    var buttonForEditing: UIButton?
    @IBAction func changeMaterial(_ sender: Any) {
        buttonForEditing = materialButton
        pickerDelegate?.setDataSource(dataSet: .Materials)
    }
    
    @IBAction func changeTAMBUnits(_ sender: Any) {
        buttonForEditing = tambButton
        pickerDelegate?.setDataSource(dataSet: .Temperature)
    }
    
    @IBAction func changeHeatFluxUnits(_ sender: Any) {
        buttonForEditing = heatFluxButton
        pickerDelegate?.setDataSource(dataSet: .EneregyDensity)
    }
    
    @IBAction func chagneTTIUnits(_ sender: Any) {
        buttonForEditing = ttiButton
        pickerDelegate?.setDataSource(dataSet: .Time)
    }
    
    func didSelectOption(option: String) {
        buttonForEditing?.setTitle(option, for: .normal)
    }
    
    // MARK: - Calculations
    
    @IBAction func calculate(_ sender: Any) {
        
        let calc = SolidIgnitionCalculator()
        let result = calc.thermallyThick(withMaterial: materialButton.titleLabel!.text!,
                                         c: specificHeatTF.text!,
                                         TAMB: tambTF.text!, TAMBUnits: tambButton.titleLabel!.text!,
                                         heatFlux: heatFluxTF.text!, heatFluxUnits: heatFluxButton.titleLabel!.text!,
                                         timeUnits: ttiButton.titleLabel!.text!)
        
        self.ttiLabel.text = result
        
    }
    
}
