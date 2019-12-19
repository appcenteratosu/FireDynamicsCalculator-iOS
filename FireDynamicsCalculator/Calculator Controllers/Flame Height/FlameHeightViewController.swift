//
//  FlameHeightViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 2/19/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class FlameHeightViewController: BaseViewController, UITextFieldDelegate {

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Flame Height"

        setupBackground()
        setupToolbar()
        setupPicker()
        setupButtons()
        
    }
    
    // MARK: - DataSource
    var viewModel = FlameHeightViewModel()
    var pickerData = [String]()
    
    // MARK: - Setup
    func setupToolbar() {
        HRR_TF.inputAccessoryView = toolbar
        diameterTF.inputAccessoryView = toolbar
        area_TF.inputAccessoryView = toolbar
    }
    
    func setupPicker() {
        self.picker.delegate = self
        self.picker.dataSource = self
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
    
    // MARK: - Actions
    @IBAction func changeHRR_Units(_ sender: Any) {
        setData(source: viewModel.heat)
        openPicker()
        buttonForEditing = HRR_Units
    }
    
    @IBAction func changeDiameter_Units(_ sender: Any) {
        setData(source: viewModel.length)
        openPicker()
        buttonForEditing = diameter_Units
    }
    
    @IBAction func changeArea_Units(_ sender: Any) {
        setData(source: viewModel.area)
        openPicker()
        buttonForEditing = area_Units
    }
    
    @IBAction func changeAvgFlameHeight_Units(_ sender: Any) {
        setData(source: viewModel.length)
        openPicker()
        buttonForEditing = avgFlameHeight_Units
    }
    
    var buttonForEditing: UIButton?
    
    @IBAction func closeView(_ sender: Any) {
        self.view.endEditing(true)
        closePicker()
    }
    
    @IBAction func calculate(_ sender: Any) {
        let calculator = FlameHeightCalculator()
        
        let lengthUnits = avgFlameHeight_Units.titleLabel!.text!
        if let hrr = Double(HRR_TF.text!), let diameter = Double(diameterTF.text!) {
            let hrrUnits = UnitPower.init(symbol: HRR_Units.titleLabel!.text!)
            let diameterUnits = UnitLength.init(symbol: diameter_Units.titleLabel!.text!)
            let lUnits = UnitLength.init(symbol: lengthUnits)
            
            let result = calculator.calculate(Q: hrr, qUnits: hrrUnits,
                                 D: diameter, dUnits: diameterUnits,
                                 lUnit: lUnits)
            avgFlameHeightLabel.text = "\(result.value.rounded(toPlaces: 3))"
            
        } else if let area = Double(area_TF.text!) {
            let areaUnits = area_Units.titleLabel!.text!
            
        }
        
        
        
        
    }
    
    // MARK: - Class Methods
    func setData(source: [String]) {
        self.pickerData = source
        self.picker.reloadAllComponents()
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
    
    func getL(value: Double, to unit: Conversion.Area.Area) -> Double {
        switch unit {
        case .FtSq:
            return value / 0.092950625
        case .inchesSq:
            return value / 0.00064549
        case .mSq:
            return value / 1.0
        }
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

extension FlameHeightViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - Picker
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
        if buttonForEditing == HRR_Units {
            HRR_Units.setTitle(selected, for: .normal)
        } else if buttonForEditing == diameter_Units {
            diameter_Units.setTitle(selected, for: .normal)
        } else if buttonForEditing == avgFlameHeight_Units {
            avgFlameHeight_Units.setTitle(selected, for: .normal)
        } else if buttonForEditing == area_Units {
            area_Units.setTitle(selected, for: .normal)
        }
    }
    
    func openPicker() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.addSubview(self.picker)
            self.view.addSubview(self.toolbar)
        }) { (done) in
            if done {
                self.picker.snp.makeConstraints({ (make) in
                    make.left.right.bottom.equalToSuperview()
                })
                self.toolbar.snp.makeConstraints({ (make) in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(self.picker.snp.top)
                    self.picker.sizeToFit()
                })
            }
        }
    }
    
    func closePicker() {
        UIView.animate(withDuration: 0.3) {
            self.picker.snp.removeConstraints()
            self.toolbar.snp.removeConstraints()
            self.picker.removeFromSuperview()
            self.toolbar.removeFromSuperview()
        }
    }
}
