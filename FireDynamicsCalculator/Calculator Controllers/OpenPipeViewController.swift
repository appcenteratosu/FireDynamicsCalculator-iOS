//
//  OpenPipeViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/9/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class OpenPipeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Open Pipe"

        setupPicker()
        setuptextfields()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
    var pickerData: [String] = []
    
    let pressure: [String] = ["Please select an option", "in H₂O", "kPa", "mbar", "psi"]
    let length: [String] = ["Please select an option", "cm", "ft", "in", "m", "mm"]
    let flow: [String] = ["Please select an option", "m³ / Hr", "m³ / Sec", "ft³ / Sec", "ft³ / Min"]

    func setDateSource(set: [String]) {
        pickerData = set
        picker.reloadAllComponents()
    }
    
    // MARK: - Picker
    @IBOutlet weak var picker: UIPickerView!
    
    func setupPicker() {
        picker.isHidden = true
        picker.dataSource = self
        picker.delegate = self
    }
    
    func showPicker() {
        self.view.endEditing(true)
        picker.isHidden = false
    }
    
    func closePicker() {
        picker.isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = pickerData[row]
        
        buttonForEditing?.setTitle(selected, for: .normal)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != picker {
                closePicker()
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet var toolbar: UIToolbar!
    @IBAction func endEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBOutlet weak var pressureTF: UITextField!
    @IBOutlet weak var diameterTF: UITextField!
    @IBOutlet weak var pipeLengthTF: UITextField!
    @IBOutlet weak var specifitGravityTF: UITextField!
    
    func setuptextfields() {
        pressureTF.inputAccessoryView = toolbar
        diameterTF.inputAccessoryView = toolbar
        pipeLengthTF.inputAccessoryView = toolbar
        specifitGravityTF.inputAccessoryView = toolbar
    }
    
    var buttonForEditing: UIButton?
    @IBOutlet weak var pressureUnits: RoundedButton!
    @IBOutlet weak var diameterUnits: RoundedButton!
    @IBOutlet weak var pipeLengthUnits: RoundedButton!
    @IBOutlet weak var flowRateUnits: RoundedButton!
    
    func setupButtons() {
        
    }
    
    @IBAction func changePressure(_ sender: Any) {
        buttonForEditing = pressureUnits
        setDateSource(set: pressure)
        showPicker()
    }
    
    @IBAction func changeDiameterUnits(_ sender: Any) {
        buttonForEditing = diameterUnits
        setDateSource(set: length)
        showPicker()
    }
    
    @IBAction func changePipeLengthUnits(_ sender: Any) {
        buttonForEditing = pipeLengthUnits
        setDateSource(set: length)
        showPicker()
    }
    
    @IBAction func changeFlowRateUnits(_ sender: Any) {
        buttonForEditing = flowRateUnits
        setDateSource(set: flow)
        showPicker()
    }
    
    @IBOutlet weak var flowRateLabel: UILabel!
    
    @IBAction func calculate(_ sender: Any) {
        calculate(dP: pressureTF.text!, dP_Units: pressureUnits.titleLabel!.text!,
                  d: diameterTF.text!, d_Units: diameterUnits.titleLabel!.text!,
                  l: pipeLengthTF.text!, l_Units: pipeLengthUnits.titleLabel!.text!,
                  Sg: specifitGravityTF.text!,
                  q_Units: flowRateUnits.titleLabel!.text!)
    }
    
    
    
    // MARK: - Calculate
    
    func calculate(dP: String, dP_Units: String, d: String, d_Units: String, l: String, l_Units: String, Sg: String, q_Units: String) {
        
        guard let drop = Double(dP) else { return }
        let drop_units = Conversion.Pressure().getPressureUnits(string: dP_Units)
        
        guard let diam = Double(d) else { return }
        let diam_units = Conversion.Length().getLengthUnits(from: d_Units)
        
        guard let len = Double(l) else { return }
        let length_units = Conversion.Length().getLengthUnits(from: l_Units)
        
        guard let sGrav = Double(Sg) else { return }
        
        let flow_units = Conversion.Flow().getFlowUnits(string: q_Units)
        
        let pressure = Conversion.Pressure().pressure(value: drop, from: drop_units)
        let diameter = Conversion.Length().convertLength(value: diam, from: diam_units) * 1000
        let length = Conversion.Length().convertLength(value: len, from: length_units)
        
        let p1 = 0.00403
        let p2 = pressure * pow(diameter, 4.8)
        let p3 = (pow(sGrav, 0.8) * length)
        let p4 = pow((p2 / p3), 0.555)
        
        let p5 = p1 * p4
        
        let result = Conversion.Flow().flow(value: p5, from: flow_units)
        
        self.flowRateLabel.text = "\(result.rounded(toPlaces: 3))"
    }

}
