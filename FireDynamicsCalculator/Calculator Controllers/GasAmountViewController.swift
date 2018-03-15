//
//  GasAmountViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/13/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class GasAmountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configure()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Data
    let gases = ["Please select an option", "Propane", "Methane", "User Specified"]
    let area = ["Please select an option", "ft²", "in²", "m²"]
    let length = ["Please select an option", "cm", "ft", "in", "m", "mm"]
    let volume = ["Please select an option", "ft³", "gallon", "in³", "liter", "m³"]
    let mass = ["Please select an option", "g", "kg", "lb"]
    
    func setDataSource(source: [String]) {
        self.pickerData = source
        picker.reloadAllComponents()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var typeOfGas: UIButton!
    @IBOutlet weak var areaUnits: UIButton!
    @IBOutlet weak var heightUnits: UIButton!
    
    @IBOutlet weak var areaOfRoom: UITextField!
    @IBOutlet weak var heightAbBlLeak: UITextField!
    
    
    // Results View
    @IBOutlet var resultsView: UIView!
    @IBOutlet weak var gasVolumeUnits: UIButton!
    @IBOutlet weak var gasWeightUnits: UIButton!
    @IBOutlet weak var liquidVolumeUnits: UIButton!
    
    @IBAction func changeGasVolumeUnits(_ sender: Any) {
        buttonForEditing = gasVolumeUnits
        setDataSource(source: volume)
        openPicker()
    }
    
    @IBAction func changeGasWeightUnits(_ sender: Any) {
        buttonForEditing = gasWeightUnits
        setDataSource(source: mass)
        openPicker()
    }
    
    @IBAction func changeLiquidVolumeUnits(_ sender: Any) {
        buttonForEditing = liquidVolumeUnits
        setDataSource(source: volume)
        openPicker()
    }
    
    @IBOutlet weak var gv_LEL: UILabel!
    @IBOutlet weak var gv_Stoich: UILabel!
    @IBOutlet weak var gv_UEL: UILabel!
    
    @IBOutlet weak var gw_LEL: UILabel!
    @IBOutlet weak var gw_Stoich: UILabel!
    @IBOutlet weak var gw_UEL: UILabel!
    
    @IBOutlet weak var lv_LEL: UILabel!
    @IBOutlet weak var lv_Stoich: UILabel!
    @IBOutlet weak var lv_UEL: UILabel!
    
    // Continue Outlets
    @IBAction func changeGasType(_ sender: Any) {
        buttonForEditing = typeOfGas
        setDataSource(source: gases)
        endTFEditing()
        openPicker()
    }
    
    @IBAction func changeAreaUnits(_ sender: Any) {
        buttonForEditing = areaUnits
        setDataSource(source: area)
        endTFEditing()
        openPicker()
    }
    
    @IBAction func changeHeightUnits(_ sender: Any) {
        buttonForEditing = heightUnits
        setDataSource(source: length)
        endTFEditing()
        openPicker()
    }
    
    // MARK: - Calculation
    @IBOutlet weak var calculateButton: UIButton!
    @IBAction func calculate(_ sender: Any) {
        calculate()
    }
    
    func calculate() {
        endTFEditing()
        closePicker()
        
        let calc = GasAmountCalculator()
        
        guard let area = areaOfRoom.text else { return }
        guard let height = heightAbBlLeak.text else { return }
        
        let resultss = calc.calculate(typeOfGas: typeOfGas.titleLabel!.text!,
                                     area: area, areaUnits: areaUnits.titleLabel!.text!,
                                     height: height, heightUnits: heightUnits.titleLabel!.text!,
                                     volGasUnit: gasVolumeUnits.titleLabel!.text!,
                                     weightGasUnit: gasWeightUnits.titleLabel!.text!,
                                     volLiqUnit: liquidVolumeUnits.titleLabel!.text!)
        guard let results = resultss else {
            showAlert(title: "Oops!", message: "Please make sure to enter a value into all fields")
            return
        }
        updateLabels(a1: results.gasVolume[.LEL]!,
                     a2: results.gasVolume[.Stoich]!,
                     a3: results.gasVolume[.UEL]!,
                     b1: results.gasWeight[.LEL]!,
                     b2: results.gasWeight[.Stoich]!,
                     b3: results.gasWeight[.UEL]!,
                     c1: results.liquidVolume[.LEL]!,
                     c2: results.liquidVolume[.Stoich]!,
                     c3: results.liquidVolume[.UEL]!)
        
        showResults()
    }
    
    func updateLabels(a1: Double, a2: Double, a3: Double,
                      b1: Double, b2: Double, b3: Double,
                      c1: Double?, c2: Double?, c3: Double?) {
        
        gv_LEL.text = "\(a1.rounded(toPlaces: 2))"
        gv_Stoich.text = "\(a2.rounded(toPlaces: 2))"
        gv_UEL.text = "\(a3.rounded(toPlaces: 2))"
        
        gw_LEL.text = "\(b1.rounded(toPlaces: 2))"
        gw_Stoich.text = "\(b2.rounded(toPlaces: 2))"
        gw_UEL.text = "\(b3.rounded(toPlaces: 2))"
        
        if c1 == nil {
            lv_LEL.text = "N/A"
        } else {
            lv_LEL.text = "\(c1!.rounded(toPlaces: 2))"
        }
        
        if c2 == nil {
            lv_Stoich.text = "N/A"
        } else {
            lv_Stoich.text = "\(c2!.rounded(toPlaces: 2))"
        }
        
        if c3 == nil {
            lv_UEL.text = "N/A"
        } else {
            lv_UEL.text = "\(c3!.rounded(toPlaces: 2))"
        }
        
    }
    
    var showingResults: Bool = false
    func showResults() {
        self.view.addSubview(resultsView)
        resultsView.snp.makeConstraints { (make) in
            make.top.equalTo(calculateButton).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(170)
        }
        showingResults = true
    }
    
    func closeResults() {
        UIView.animate(withDuration: 0.2, animations: {
            self.resultsView.transform.scaledBy(x: 0.05, y: 0.05)
        }) { (done) in
            if done {
                self.resultsView.removeFromSuperview()
            }
        }
        showingResults = false
    }
    
    // MARK: - Setup
    func configure() {
        setupTextfields()
        setupPicker()
        setupButtons()
    }
    
    func setupTextfields() {
        areaOfRoom.delegate = self
        heightAbBlLeak.delegate = self
        
        areaOfRoom.inputAccessoryView = toolbar
        heightAbBlLeak.inputAccessoryView = toolbar
        
        areaOfRoom.keyboardType = .decimalPad
        heightAbBlLeak.keyboardType = .decimalPad
    }
    
    func setupPicker() {
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
    }
    
    func setupButtons() {
        areaUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        heightUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    }
    
    
    // MARK: - Toolbar
    @IBOutlet var toolbar: UIToolbar!
    @IBAction func doneEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    // MARK: - Picker
    @IBOutlet weak var picker: UIPickerView!
    
    var buttonForEditing: UIButton?
    var pickerData: [String] = []
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
        
        if showingResults {
            buttonForEditing?.setTitle(selected, for: .normal)
            calculate()
        } else {
            buttonForEditing?.setTitle(selected, for: .normal)
        }
        
    }
    
    func openPicker() {
        picker.isHidden = false
        picker.selectRow(0, inComponent: 0, animated: false)
    }
    
    func closePicker() {
        picker.isHidden = true
    }
    
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != picker {
                closePicker()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if picker.isHidden == false {
            closePicker()
        }
    }
    
    func endTFEditing() {
        self.view.endEditing(true)
    }
    
    // Utilities
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

}

struct GasAmountCalculator {
    
    enum Gases {
        case Methane
        case Propane
        case UserSpecified
    }
    
    enum GasProps {
        case LEL
        case Stoich
        case UEL
        case VaporDensity
        case LiquidDensity
    }
    
    let gasData: [Gases : [GasProps: Double]] = [.Methane: [.LEL: 0.05, .Stoich: 0.0952, .UEL: 0.15, .VaporDensity: 0.6407, .LiquidDensity: 0.0],
                                                 .Propane: [.LEL: 0.021, .Stoich: 0.0626, .UEL: 0.095, .VaporDensity: 1.554, .LiquidDensity: 580],
                                                 .UserSpecified: [.LEL: 0.02, .Stoich: 0.045, .UEL: 0.09, .VaporDensity: 1.8, .LiquidDensity: 540]]
    
    struct Results {
        var gasVolume: [GasProps: Double]
        var gasWeight: [GasProps: Double]
        var liquidVolume: [GasProps: Double?]
    }
    
    func calculate(typeOfGas: String, area: String, areaUnits: String, height: String, heightUnits: String, volGasUnit: String, weightGasUnit: String, volLiqUnit: String) -> Results? {
        
        if area == "" || height == "" {
            return nil
        } else {
            var gasType: Gases
            
            switch typeOfGas {
            case "Propane":
                gasType = .Propane
            case "Methane":
                gasType = .Methane
            case "User Specified":
                gasType = .UserSpecified
            default:
                gasType = .Propane
            }
            
            let area = Conversion.Area().area(value: Double(area) ?? 0.0, from: Conversion.Area().getAreaUnits(from: areaUnits))
            let height = Conversion.Length().convertLength(value: Double(height) ?? 0.0, from: Conversion.Length().getLengthUnits(from: heightUnits))
            let vAboveBelow = area * height
            
            let gasInfo = gasData[gasType]!
            
            let LEL = gasInfo[.LEL]!
            let Stoich = gasInfo[.Stoich]!
            let UEL = gasInfo[.UEL]!
            
            let vaporDensity = gasInfo[.VaporDensity]!
            let liqDensity = gasInfo[.LiquidDensity]!
            let liqDensityConv = Conversion.Volume().convertVolume(value: liqDensity, from: Conversion.Volume().getUnits(string: volLiqUnit))
            
            // gas vol
            let a1 = Conversion.Volume().convertToCubM(value: (LEL * vAboveBelow), from: Conversion.Volume().getUnits(string: volGasUnit))
            let b1 = Conversion.Volume().convertToCubM(value: (Stoich * vAboveBelow), from: Conversion.Volume().getUnits(string: volGasUnit))
            let c1 = Conversion.Volume().convertToCubM(value: (UEL * vAboveBelow), from: Conversion.Volume().getUnits(string: volGasUnit))
            
            // gas weight
            let a2 = Conversion.Mass().convertToKg(value: (a1 * vaporDensity), from: Conversion.Mass().getUnits(string: weightGasUnit))
            let b2 = Conversion.Mass().convertToKg(value: (b1 * vaporDensity), from: Conversion.Mass().getUnits(string: weightGasUnit))
            let c2 = Conversion.Mass().convertToKg(value: (c1 * vaporDensity), from: Conversion.Mass().getUnits(string: weightGasUnit))
            
            // liq vol
            var a3: Double?
            var b3: Double?
            var c3: Double?
            
            if liqDensity != 0.0 {
                a3 = Conversion.Mass().convertMass(value: a2, from: Conversion.Mass().getUnits(string: weightGasUnit)) / liqDensityConv
                b3 = Conversion.Mass().convertMass(value: b2, from: Conversion.Mass().getUnits(string: weightGasUnit)) / liqDensityConv
                c3 = Conversion.Mass().convertMass(value: c2, from: Conversion.Mass().getUnits(string: weightGasUnit)) / liqDensityConv
            } else {
                a3 = nil
                b3 = nil
                c3 = nil
            }
            
            
            let results = Results(gasVolume: [.LEL: a1, .Stoich: b1, .UEL: c1],
                                  gasWeight: [.LEL: a2, .Stoich: b2, .UEL: c2],
                                  liquidVolume: [.LEL: a3, .Stoich: b3, .UEL: c3])
            
            return results
        }
        
    }
    
    
}
