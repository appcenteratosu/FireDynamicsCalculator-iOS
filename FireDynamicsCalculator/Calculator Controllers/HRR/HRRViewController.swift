//
//  HRRViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 2/16/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class HRRViewController: BaseViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Heat Release Rate"
        setupBackground()
        setupPicker()
        setupMisc()
        setupTextFields()
        setupToolbar()
    }

    // MARK: - Properties
    var viewModel = HRRViewModel()
    var calculator = HRRCalculator()
    
    var pickerData: [String] = []
    var selectedButton: UIButton?
    
    // MARK: - Outlets
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var toolbar: UIToolbar!
    @IBAction func toolbarDoneButton(_ sender: UIBarButtonItem) {
        
        hidePicker()
    }
    
    @IBOutlet weak var selectMethodButton: RoundedButton!
    
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var selectFuelButton: RoundedButton!
    
    @IBOutlet weak var selectedAreaLabel: UILabel!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var areaUnitsButton: RoundedButton!
    
    @IBOutlet weak var qLabel: UILabel!
    @IBOutlet weak var qUnitButton: UIButton!
    
    @IBOutlet weak var calculateButton: RoundedButton!
    
    // MARK: - Actions
    @IBAction func selectMethod(_ sender: RoundedButton) {
        // Set picker data
        pickerData = viewModel.methodChoices
        pickerView.reloadAllComponents()
        
        // Set selected button
        selectedButton = sender
        
        // Show picker
        showPicker()
    }
    @IBAction func selectFuel(_ sender: RoundedButton) {
        // Set picker data
        pickerData = viewModel.fuelChoices
        pickerView.reloadAllComponents()
        
        // Set selected button
        selectedButton = sender
        
        // Show picker
        if let index = viewModel.fuelChoices.index(of: sender.titleLabel!.text!) {
            showPicker(at: index)
        } else {
            showPicker()
        }
    }
    @IBAction func selectAreaUnit(_ sender: RoundedButton) {
        // set picker data
        if selectMethodButton.titleLabel?.text == "Area" {
            pickerData = viewModel.areaChoices
        } else {
            pickerData = viewModel.lengthChoices
        }
        pickerView.reloadAllComponents()
        
        // Set selected button
        selectedButton = sender
        
        // Show picker
        if let index = viewModel.areaChoices.index(of: sender.titleLabel!.text!) {
            showPicker(at: index)
        }
    }
    @IBAction func selectQUnits(_ sender: RoundedButton) {
        // Set picker data
        pickerData = viewModel.energyChoices
        pickerView.reloadAllComponents()
        
        // Set selected button
        selectedButton = sender
        
        // Show picker
        if let index = viewModel.energyChoices.index(of: sender.titleLabel!.text!) {
            showPicker(at: index)
        }
    }
    @IBAction func calculate(_ sender: RoundedButton) {
        // Grab all values
        // Determine method
        // Calculate
        // Set labels
        do {
            try calculate()
        } catch {
            print(error)
        }
    }
    
    enum CalculateError: Error {
        case fuelNotSelected
        case areaNotEntered
        case areaUnitsNotSelected
        case lengthNotEntered
        case lengthUnitsNotSelected
        case qUnitsNotSelected
        case noMethodFound
    }
    
    // MARK: - Class Methods
    func calculate() throws {
        
        guard let method = selectMethodButton.titleLabel?.text else {
            throw CalculateError.noMethodFound
        }
        
        guard let fuel = viewModel.fuelData[selectFuelButton.titleLabel!.text!] else {
            // Show error
            throw CalculateError.fuelNotSelected
        }
        
        if method == "Area" {
            guard let area = Double(areaTextField.text!.isEmpty ? "" : areaTextField.text!) else {
                throw CalculateError.areaNotEntered
            }
            
            let areaUnits: UnitArea? = {
                let text = areaUnitsButton.titleLabel!.text!
                if text == viewModel.areaChoices[1] {
                    return .squareMeters
                } else if text == viewModel.areaChoices[2] {
                    return .squareFeet
                } else if text == viewModel.areaChoices[3] {
                    return .squareInches
                } else {
                    return nil
                }
            }()
            guard areaUnits != nil else {
                throw CalculateError.areaUnitsNotSelected
            }
            
            let qUnits: UnitPower? = {
                let text = qUnitButton.titleLabel!.text!
                if text == viewModel.energyChoices[1] {
                    return .kilowatts
                } else if text == viewModel.energyChoices[2] {
                    return .btuPerSecond
                } else {
                    return nil
                }
            }()
            guard qUnits != nil else {
                throw CalculateError.qUnitsNotSelected
            }
            
            let hrr = calculator.calculate(fuel: fuel, area: area, areaUnits: areaUnits!, qUnit: qUnits!).rounded(toPlaces: 2)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            guard let formattedNumber = numberFormatter.string(from: NSNumber(value: hrr)) else {
                return
            }
            self.qLabel.text = "\(formattedNumber)"
        } else {
            guard let radius = Double(areaTextField.text!.isEmpty ? "" : areaTextField.text!) else {
                throw CalculateError.lengthNotEntered
            }
            
            let radiusUnits: UnitLength? = {
                let text = areaUnitsButton.titleLabel!.text!
                if text == viewModel.lengthChoices[1] {
                    return .centimeters
                } else if text == viewModel.lengthChoices[2] {
                    return .feet
                } else if text == viewModel.lengthChoices[3] {
                    return .inches
                } else if text == viewModel.lengthChoices[4] {
                    return .meters
                } else if text == viewModel.lengthChoices[5] {
                    return .millimeters
                } else {
                    return nil
                }
            }()
            guard radiusUnits != nil else {
                throw CalculateError.lengthUnitsNotSelected
            }
            
            let qUnits: UnitPower? = {
                let text = qUnitButton.titleLabel!.text!
                if text == viewModel.energyChoices[1] {
                    return .kilowatts
                } else if text == viewModel.energyChoices[2] {
                    return .btuPerSecond
                } else {
                    return nil
                }
            }()
            guard qUnits != nil else {
                throw CalculateError.qUnitsNotSelected
            }
            
            let hrr = calculator.calculate(fuel: fuel, radius: radius, lengthUnits: radiusUnits!, qUnit: qUnits!).rounded(toPlaces: 2)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            guard let formattedNumber = numberFormatter.string(from: NSNumber(value: hrr)) else {
                return
            }
            self.qLabel.text = "\(formattedNumber)"
        }
        
    }
    
    func showPicker(at index: Int = 0) {
        self.pickerView.isHidden = false
        self.view.addSubview(self.toolbar)
        self.toolbar.isHidden = false
        self.toolbar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.pickerView.snp.top)
            self.toolbar.sizeToFit()
        }
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    func hidePicker() {
        self.view.endEditing(true)
        self.pickerView.isHidden = true
        self.toolbar.isHidden = true
        self.toolbar.snp.removeConstraints()
    }
    
    // MARK: - Setup
    func setupPicker() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.view.addSubview(self.pickerView)
        self.pickerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            self.pickerView.sizeToFit()
        }
        self.pickerView.isHidden = true
    }
    
    func setupToolbar() {
        self.view.addSubview(self.toolbar)
        self.toolbar.isHidden = true
    }
    
    func setupMisc() {
        qLabel.layer.cornerRadius = 5
        qLabel.clipsToBounds = true
        fuelLabel.text = ""
    }
    
    func setupTextFields() {
        areaTextField.delegate = self
        areaTextField.inputAccessoryView = toolbar
    }
    
}

extension HRRViewController {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == areaTextField {
            self.toolbar.removeFromSuperview()
            self.toolbar.isHidden = false
        }
        
        return true
    }
}


extension HRRViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        
        let selectedItem = pickerData[row]
        
        if selectedButton == selectMethodButton {
            switch selectedItem {
            case "Area":
                selectedAreaLabel.text = "Area:"
                areaUnitsButton.setTitle(viewModel.areaChoices[0], for: .normal)
            case "Radius":
                selectedAreaLabel.text = "Radius:"
                areaUnitsButton.setTitle(viewModel.lengthChoices[0], for: .normal)
            default:
                break
            }
        }
        
        if selectedButton == selectFuelButton {
            fuelLabel.text = selectedItem
        }
        
        selectedButton?.setTitle(selectedItem, for: .normal)
        
    }
    
}
