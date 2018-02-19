//
//  HRRViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 2/16/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class HRRViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPicker()
        setupKeyboard()
        
        setupButtons()
        
        
    }

    // MARK: - Outlets and Actions
    
    func setupButtons() {
        hrrqButton.titleLabel?.sizeToFit()
        areaUnitsButton.titleLabel?.sizeToFit()
        selectedFuelLabel.text = ""
    }
    
    @IBOutlet weak var methodButton: RoundedButton!
    @IBAction func changeMethod(_ sender: UIButton) {
        self.view.endEditing(true)
        buttonForEditing = methodButton
        methodButton.titleLabel?.textAlignment = .center
        setDataSource(data: methodChoices)
        showPicker()
    }
    
    
    @IBOutlet weak var selectedFuelLabel: UILabel!
    @IBOutlet weak var fuelButton: RoundedButton!
    @IBAction func changeFuel(_ sender: UIButton) {
        self.view.endEditing(true)
        fuelButton.titleLabel?.textAlignment = .center
        buttonForEditing = fuelButton
        setDataSource(data: fuelChoices)
        showPicker()
    }
    
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var areaTF: UITextField!
    @IBOutlet weak var areaUnitsButton: RoundedButton!
    @IBAction func changeAreaUnits(_ sender: UIButton) {
        buttonForEditing = areaUnitsButton
        self.view.endEditing(true)
        if self.method == .area {
            setDataSource(data: areaChoices)
            showPicker()
        } else if self.method == .radius {
            setDataSource(data: lengthChoices)
            showPicker()
        }
    }
    
    @IBOutlet weak var HRRQLabel: UILabel!
    @IBOutlet weak var hrrqButton: RoundedButton!
    @IBAction func changeHRRQUnits(_ sender: UIButton) {
        self.view.endEditing(true)
        buttonForEditing = hrrqButton
        setDataSource(data: energyChoices)
        showPicker()
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    var buttonForEditing: UIButton?
    
    // MARK: - PickerView Setup
    func setupPicker() {
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.isHidden = true
    }
    
    func showPicker() {
        picker.isHidden = false
        picker.selectRow(0, inComponent: 0, animated: false)
    }
    
    func hidePicker() {
        picker.isHidden = true
    }
    
    @IBOutlet var toolbar: UIToolbar!
    @IBAction func hide(_ sender: Any) {
        if let area = areaTF.text {
            if area.count > 0 {
                if let value = Double(area) {
                    self.Area = value
                }
            }
        }
        self.view.endEditing(true)
    }
    
    var pickerItems: [String] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if buttonForEditing == methodButton {
            
            // get selected method
            let method = pickerItems[row]
            
            // set selected method to button label
            self.methodButton.setTitle(method, for: .normal)
            
            // set selected method to area label
            self.areaLabel.text = method
            
            // update picker data if Radius is selected
            if method == "Radius" {
                areaUnitsButton.setTitle("Meters", for: .normal)
                
            }
            
            // set method in class variable
            setMethod(methodS: method)
            
            // close picker
            hidePicker()
            
        } else if buttonForEditing == fuelButton {
            // get selected fuel type
            let fuel = pickerItems[row]
            
            // set selected fuel to button label
            self.fuelButton.setTitle(fuel, for: .normal)
            self.selectedFuelLabel.text = fuel
            
            // set fuel in class variable
            setFuel(fuel: fuel)
            
            // close picker
            hidePicker()
            
        } else if buttonForEditing == areaUnitsButton {
            
            // get selected units
            let units = pickerItems[row]
            
            // set selected units to button label
            self.areaUnitsButton.setTitle(units, for: .normal)
            
            
            switch units {
            case "ft^2":
                self.AreaConversionFactor = 0.092950625
            case "inch^2":
                self.AreaConversionFactor = 0.00064549
            case "m^2":
                self.AreaConversionFactor = 1.0
            case "cm":
                self.AreaConversionFactor = 0.01
            case "feet":
                self.AreaConversionFactor = 0.304878049
            case "inches":
                self.AreaConversionFactor = 0.025406504
            case "meters":
                self.AreaConversionFactor = 1
            case "mm":
                self.AreaConversionFactor = 0.001
            default:
                print("Error getting conversion factor")
            }
            
            if let str = self.areaTF.text {
                if let value = Double(str) {
                    self.Area = value
                }
            }
            
            hidePicker()
            
        } else if buttonForEditing == hrrqButton {
            let units = pickerItems[row]
            self.hrrqButton.setTitle(units, for: .normal)
            
            switch units {
            case "kW":
                self.QConversionFactor = 1
            case "Btu / sec":
                self.QConversionFactor = 1.055055852
            default:
                print("error converting area")
            }
            
        }
        
        hidePicker()
    }
    
    func setDataSource(data: [String]) {
        pickerItems = data
        picker.reloadAllComponents()
    }
    
    // MARK: - PickerData
    var methodChoices = ["Please Select an Option",
                         "Area",
                         "Radius"]
    
    var fuelChoices = ["Please Select an Option",
                       "Cellulose",
                       "Gasoline",
                       "Heptane",
                       "Methanol",
                       "PMMA",
                       "Polyethylene",
                       "Polypropylene",
                       "Polystyrene",
                       "PVC",
                       "Wood"]
    
    var areaChoices = ["Please Select an Option",
                       "m^2",
                       "ft^2",
                       "inch^2"]
    
    var energyChoices = ["Please Select am Option",
                         "kW",
                         "Btu / sec"]
    
    var lengthChoices = ["Please Select an Option",
                         "cm",
                         "feet",
                         "inches",
                         "meters",
                         "mm"]
    
    // MARK: - Calculations
    var method: HRR.Method = .area
    var Fuel: HRR.Fuel?
    var MBF: Int = 0
    var EHC: Double = 0.0
    var Area: Double = 0.0
    var AreaConversionFactor: Double = 1.0
    var Radius: Double = 0.0
    var QConversionFactor: Double = 1.0
    
    var HRR: Double = 0.0
    
    
    @IBAction func calculateButton(_ sender: UIButton) {
        calculate()
    }
    
    
    func calculate() {
        
        switch self.method {
        case .area:
            
            print("MBF:", MBF)
            print("EHC:", EHC)
            print("Area:", Area)
            print("QConersionFactor:", QConversionFactor)
            print("Area Conversion Factor:", AreaConversionFactor)
            
            self.HRR = (((Double(MBF) * EHC * (Area * AreaConversionFactor)) * QConversionFactor)).rounded(toPlaces: 2)
            self.HRRQLabel.text = "\(self.HRR)"
        case .radius:
            let area = areaFrom(radius: Area)
            self.Area = area
            
            print("MBF:", MBF)
            print("EHC:", EHC)
            print("Area:", Area)
            print("QConersionFactor:", QConversionFactor)
            print("Area Conversion Factor:", AreaConversionFactor)
                
            self.HRR = (((Double(MBF) * EHC * Area) * QConversionFactor)).rounded(toPlaces: 2)
            self.HRRQLabel.text = "\(self.HRR)"
        }
    }
    
    func setMethod(methodS: String) {
        switch methodS {
        case "Area":
            self.method = .area
        case "Radius":
            self.method = .radius
        default:
            print("Error setting method")
        }
    }
    
    func setFuel(fuel: String) {
        switch fuel {
        case "Cellulose":
            self.Fuel = .Cellulose
        case "Gasoline":
            self.Fuel = .Gasoline
        case "Heptane":
            self.Fuel = .Heptane
        case "Methanol":
            self.Fuel = .Methanol
        case "PMMA":
            self.Fuel = .PMMA
        case "Polyethylene":
            self.Fuel = .Polyethylene
        case "Polypropylene":
            self.Fuel = .Polypropylene
        case "Polystyrene":
            self.Fuel = .Polystyrene
        case "PVC":
            self.Fuel = .PVC
        case "Wood":
            self.Fuel = .Wood
        default:
            print("Error setting Fuel")
        }
        
        self.EFHCConstant(fuel: self.Fuel!)
        self.MBFConstant(fuel: self.Fuel!)
    }
    
    func setArea() {
        guard let areaString = self.areaTF.text else {
            return
        }
        
        guard let area = Double(areaString) else {
            return
        }
        
        self.Area = area
        
    }
    
    func areaFrom(radius: Double) -> Double {
        let meters = radius * AreaConversionFactor
        let a = (Double.pi * (meters * meters))
        return a
    }
    
    func MBFConstant(fuel: HRR.Fuel) {
        switch fuel {
        case .Cellulose:
            self.MBF = 14
        case .Gasoline:
            self.MBF = 55
        case .Heptane:
            self.MBF = 70
        case .Methanol:
            self.MBF = 22
        case .PMMA:
            self.MBF = 28
        case .Polyethylene:
            self.MBF = 26
        case .Polypropylene:
            self.MBF = 24
        case .Polystyrene:
            self.MBF = 38
        case .PVC:
            self.MBF = 16
        case .Wood:
            self.MBF = 11
        }
    }
    
    func EFHCConstant(fuel: HRR.Fuel) {
        switch fuel {
        case .Cellulose:
            self.EHC = 16.1
        case .Gasoline:
            self.EHC = 43.7
        case .Heptane:
            self.EHC = 44.6
        case .Methanol:
            self.EHC = 19.8
        case .PMMA:
            self.EHC = 24.9
        case .Polyethylene:
            self.EHC = 43.3
        case .Polypropylene:
            self.EHC = 43.3
        case .Polystyrene:
            self.EHC = 39.8
        case .PVC:
            self.EHC = 16.4
        case .Wood:
            self.EHC = 14.0
        }
    }
    
    func convertArea(area: Double, to unit: Conversion.Units.Area) -> Double {
        let area = Conversion().area(value: area, to: unit)
        return area
    }
    
    func convertEnergy(area: Double, to unit: Conversion.Units.Energy) {
        self.HRR = Conversion().energy(value: area, to: unit)
    }
    
    func convertLength(length: Double, to unit: Conversion.Units.Length) {
        self.Radius = Conversion().length(value: length, from: unit)
    }
    
    struct HRR {
        enum Fuel {
            case Cellulose
            case Gasoline
            case Heptane
            case Methanol
            case PMMA
            case Polyethylene
            case Polypropylene
            case Polystyrene
            case PVC
            case Wood
        }
    
        enum Method {
            case radius
            case area
        }
    
    }
    
    // MARK: - Keyboard
    func setupKeyboard() {
        areaTF.delegate = self
        areaTF.inputAccessoryView = toolbar
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }

}
