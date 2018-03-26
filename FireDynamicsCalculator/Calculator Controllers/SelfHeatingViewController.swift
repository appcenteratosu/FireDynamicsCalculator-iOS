//
//  SelfHeatingViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/16/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class SelfHeatingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        self.title = "Self Heating"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Data
    let lengths = Conversion.UnitString().length
    let volumes = Conversion.UnitString().volume
    let temperatures = Conversion.UnitString().temperature
    let materials = SelfHeatingCalculator().materials.toStringArray()
    
    // MARK: - Outlets
    @IBOutlet weak var volume: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var temperature: UITextField!
    
    @IBOutlet weak var material: UIButton!
    
    @IBOutlet weak var volumeUnits: UIButton!
    @IBOutlet weak var heightUnits: UIButton!
    @IBOutlet weak var temperatureUnits: UIButton!
    
    @IBOutlet weak var alpha: UILabel!
    
    @IBAction func changeVolumeUnits(_ sender: Any) {
        self.view.endEditing(true)
        buttonForEditing = volumeUnits
        setDataSource(source: volumes)
        openPicker()
    }
    
    @IBAction func changeHeightUnits(_ sender: Any) {
        self.view.endEditing(true)
        buttonForEditing = heightUnits
        setDataSource(source: lengths)
        openPicker()
    }
    
    @IBAction func changeTemperatureUnits(_ sender: Any) {
        self.view.endEditing(true)
        buttonForEditing = temperatureUnits
        setDataSource(source: temperatures)
        openPicker()
    }
    
    @IBAction func changeMaterial(_ sender: Any) {
        self.view.endEditing(true)
        buttonForEditing = material
        setDataSource(source: materials)
        openPicker()
    }
    
    @IBAction func calculate(_ sender: Any) {
        let calc = SelfHeatingCalculator()
        
        if let result = calc.calculate(v: volume.text!, vUnits: volumeUnits.titleLabel!.text!,
                       h: height.text!, hUnits: heightUnits.titleLabel!.text!,
                       material: material.titleLabel!.text!,
                       t: temperature.text!, tUnits: temperatureUnits.titleLabel!.text!) {
           
            
            self.alpha.text = "\(result)"
        }
    }
    
    // MARK: - Setup
    
    func configure() {
        setupPicker()
        setupButtons()
        setupTextField()
    }
    
    func setupButtons() {
        volumeUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        heightUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        temperatureUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        material.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        material.setTitle("Select...", for: .normal)
    }
    
    func setupTextField() {
        volume.delegate = self
        height.delegate = self
        temperature.delegate = self
        
        volume.inputAccessoryView = toolbar
        height.inputAccessoryView = toolbar
        temperature.inputAccessoryView = toolbar
        
        alpha.text = ""
    }
    
    func setupPicker() {
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
    }
    
    
    // MARK: - Toolbar
    @IBOutlet var toolbar: UIToolbar!
    @IBAction func endEditingButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Picker
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = []
    var buttonForEditing: UIButton?
    func setDataSource(source: [String]) {
        pickerData = source
        picker.reloadAllComponents()
    }
    
    func openPicker() {
        picker.isHidden = false
        picker.selectRow(0, inComponent: 0, animated: true)
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
    
    
    // MARK: - Extra
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != picker {
                closePicker()
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if picker.isHidden {
            
        } else {
            closePicker()
        }
    }
    


}


struct SelfHeatingCalculator {
    
    func calculate(v: String, vUnits: String,
                   h: String, hUnits: String,
                   material: String,
                   t: String, tUnits: String) -> Double? {
        
        guard let volume = Double(v) else { return nil}
        guard let height = Double(h) else { return nil }
        guard let material = materials[material] else { return nil }
        
        let volume_Conv = Conversion.Volume().convertVolume(value: volume, from: Conversion.Volume().getUnits(string: vUnits))
        let height_Conv = Conversion.Length().convertLength(value: height, from: Conversion.Length().getLengthUnits(from: hUnits))
        
        let area = (volume_Conv / height_Conv).rounded(toPlaces: 2)
        let r = ((sqrt(area) / Double.pi) * 1000).rounded(toPlaces: 2)
        
        let m = material["M"]!
        let p = material["P"]!
        
        let t_conv = Conversion.Temperature().TGasConv(value: t, from: Conversion.Temperature().getTemperatureUnits(string: tUnits))
        
        let alpha = ((pow(r, 2.0)) / (pow(t_conv, 2.0)) * exp(m - p / t_conv)).rounded(toPlaces: 4)
        
        return alpha
    }
    
    
    let materials = ["Ammonium Nitrate": ["P": 17921, "M": 43.2],
                     "Animal Feedstuff": ["P": 8404, "M": 26.06],
                     "Bagasse": ["P": 13000, "M": 33.08],
                     "Cellulose Insulation": ["P": 13230, "M": 32.8],
                     "Coal": ["P": 8419, "M": 25],
                     "Cotton": ["P": 11282, "M": 28.6],
                     "Forest Floor Material I": ["P": 9862, "M": 27.2],
                     "Plywood": ["P": 10572, "M": 32.9],
                     "Wheat Flour": ["P": 15539, "M": 44.2],
                     "Wood Fiberboard": ["P": 12145, "M": 34.55]]
    
}
