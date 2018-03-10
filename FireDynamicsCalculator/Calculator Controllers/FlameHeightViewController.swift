//
//  FlameHeightViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 2/19/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class FlameHeightViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Flame Height"

        setupToolbar()
        setupPicker()
        setupButtons()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DataSource
    let length: [String] = ["Please Select an option", "m", "cm", "ft", "mm", "in"]
    let heat: [String] = ["Please Select an option", "kW", "Btu / Sec"]
    let area: [String] = ["Please Select an option", "m²", "ft²", "in²"]
    
    var currentDataSet: [String] = []
    
    // MARK: - Setup Items
    func setupToolbar() {
        HRR_TF.inputAccessoryView = toolbar
        diameterTF.inputAccessoryView = toolbar
        area_TF.inputAccessoryView = toolbar
    }
    
    func setupPicker() {
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.isHidden = true
    }
    
    func setupButtons() {
        HRR_Units.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        diameter_Units.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        area_Units.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        avgFlameHeight_Units.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    }

    // MARK: - Outlets
    @IBOutlet weak var HRR_TF: UITextField!
    @IBOutlet weak var HRR_Units: UIButton!
    
    @IBOutlet weak var diameterTF: UITextField!
    @IBOutlet weak var diameter_Units: UIButton!
    
    @IBOutlet weak var area_TF: UITextField!
    @IBOutlet weak var area_Units: UIButton!
    
    @IBOutlet weak var avgFlameHeightLabel: UILabel!
    @IBOutlet weak var avgFlameHeight_Units: UIButton!
    
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet weak var picker: UIPickerView!
    
    // MARK: - Buttons
    @IBAction func changeHRR_Units(_ sender: Any) {
        setData(source: heat)
        openPicker()
        buttonForEditing = HRR_Units
    }
    
    @IBAction func changeDiameter_Units(_ sender: Any) {
        setData(source: length)
        openPicker()
        buttonForEditing = diameter_Units
    }
    
    @IBAction func changeArea_Units(_ sender: Any) {
        setData(source: area)
        openPicker()
        buttonForEditing = area_Units
    }
    
    @IBAction func changeAvgFlameHeight_Units(_ sender: Any) {
        setData(source: length)
        openPicker()
        buttonForEditing = avgFlameHeight_Units
    }
    
    var buttonForEditing: UIButton?
    
    @IBAction func closeView(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func calculate(_ sender: Any) {
        
        guard let hrr = HRR_TF.text else {
            return
        }
        
        guard let qq = Double(hrr) else {
            return
        }
        
        let qUnits = Conversion.Energy().getEnergyUnits(from: getUnits(button: HRR_Units))

        let q = Conversion.Energy().energy(value: qq, from: qUnits)
        
        if diameterTF.isEnabled {
            guard let diam = diameterTF.text else {
                return
            }
            guard let dd = Double(diam) else {
                return
            }
            let units = Conversion.Length().getLengthUnits(from: getUnits(button: diameter_Units))
            let d = Conversion.Length().convertLength(value: dd, from: units)
            
            let result = calculateDiam(q: q, diam: d)
            let avgFlameUnits = Conversion.Length().getLengthUnits(from: getUnits(button: avgFlameHeight_Units))
            
            
            let avgFlameHeight = getL(value: result, to: avgFlameUnits)
            avgFlameHeightLabel.text = "Average Flame Height: \(avgFlameHeight.rounded(toPlaces: 2))"
        } else if area_TF.isEnabled {
            guard let a = area_TF.text else { return }
            guard let area = Double(a) else { return }
            let diameter = diameterFrom(area: area)
            
            let result = calculateDiam(q: q, diam: diameter)
            let avgFlameUnits = Conversion.Length().getLengthUnits(from: getUnits(button: avgFlameHeight_Units))
            
            let avgFlameHeight = getL(value: result, to: avgFlameUnits)
            avgFlameHeightLabel.text = "Average Flame Height: \(avgFlameHeight.rounded(toPlaces: 2))"
            
        }
        
    }
    
    func getUnits(button: UIButton) -> String {
        let units = button.titleLabel!.text!
        return units
    }
    
    func calculateDiam(q: Double, diam: Double) -> Double {
        return (0.23 * pow(q,0.4)-1.02 * diam)
    }
    
    func diameterFrom(area: Double) -> Double {
        let a = area / Double.pi
        let b = sqrt(a)
        let units = Conversion.Area().getAreaUnits(from: getUnits(button: area_Units))
        let r = getL(value: b, to: units)
        let diameter = r * 2
        return diameter
    }
    
    func getL(value: Double, to unit: Conversion.Length.Length) -> Double {
        switch unit {
        case .cm:
            return value / 0.01
        case .feet:
            return value / 0.304878049
        case .inches:
            return value / 0.025406504
        case .meters:
            return value / 1.0
        case .mm:
            return value / 0.001
        }
    }
    
    func getL(value: Double, to unit: Conversion.Units.Area) -> Double {
        switch unit {
        case .FtSq:
            return value / 0.092950625
        case .inchesSq:
            return value / 0.00064549
        case .mSq:
            return value / 1.0
        }
    }
    
    
    // MARK: - Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentDataSet.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentDataSet[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentDataSet == heat {
            let title = heat[row]
            HRR_Units.setTitle(title, for: .normal)
            closePicker()
            
        } else if currentDataSet == length {
            if buttonForEditing == diameter_Units {
                let title = length[row]
                diameter_Units.setTitle(title, for: .normal)
                closePicker()
            } else {
                let title = length[row]
                avgFlameHeight_Units.setTitle(title, for: .normal)
                closePicker()
            }
            
        } else if currentDataSet == area {
            let title = area[row]
            area_Units.setTitle(title, for: .normal)
            closePicker()
        }
    }
    
    func openPicker() {
        self.picker.isHidden = false
        self.picker.selectRow(0, inComponent: 0, animated: false)
    }
    
    func closePicker() {
        self.picker.isHidden = true
    }
    
    // MARK: - Functionality
    func setData(source: [String]) {
        self.currentDataSet = source
        self.picker.reloadAllComponents()
    }

    
    
    // MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == HRR_TF {
            diameterTF.becomeFirstResponder()
        } else if textField == diameterTF {
            textField.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == diameterTF {
            if let value = textField.text {
                if value.count > 0 {
                    area_TF.isEnabled = false
                } else {
                    area_TF.isEnabled = true
                }
            }
        } else if textField == area_TF {
            if let value = textField.text {
                if value.count > 0 {
                    diameterTF.isEnabled = false
                } else {
                    diameterTF.isEnabled = true
                }
            }
        }
    }
    
    
}
