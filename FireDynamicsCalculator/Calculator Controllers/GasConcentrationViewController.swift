//
//  GasConcentrationViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/10/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class GasConcentrationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Gas Concentration"
        configure()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
    let flow = ["m³ / Hr", "m³ / Sec", "ft³ / Sec", "ft³ / Min"]
    let volume = ["ft³", "gallon", "in³", "liter", "m³"]
    
    // MARK: - Outlets
    @IBOutlet weak var airchangeTF: UITextField!
    @IBOutlet weak var leakageRateTF: UITextField!
    @IBOutlet weak var volumeTF: UITextField!
    @IBOutlet weak var timestepTF: UITextField!
    
    @IBOutlet weak var leakageRateUnits: UIButton!
    @IBOutlet weak var volumeUnits: UIButton!
    
    @IBAction func changeLeakageRate(_ sender: Any) {
        buttonForEditing = leakageRateUnits
        setDataDource(source: flow)
        openPicker()
    }
    
    @IBAction func changeVolumeUnits(_ sender: Any) {
        buttonForEditing = volumeUnits
        setDataDource(source: volume)
        openPicker()
    }
    
    @IBAction func calculate(_ sender: Any) {
        let set = createDataSet(airChanges: airchangeTF.text!,
                      gasLeakage: leakageRateTF.text!,
                      gasLeakageUnits: leakageRateUnits.titleLabel!.text!,
                      volume: volumeTF.text!,
                      volumeUnits: volumeUnits.titleLabel!.text!,
                      timestep: timestepTF.text!)
        
        performSegue(withIdentifier: "showGraph", sender: set)
    }
    
    var buttonForEditing: UIButton?
    
    // MARK: - Setup
    func configure() {
        setupButtons()
        setupTextFields()
        setupPicker()
    }
    
    func setupTextFields() {
        airchangeTF.inputAccessoryView = toolbar
        leakageRateTF.inputAccessoryView = toolbar
        volumeTF.inputAccessoryView = toolbar
        timestepTF.inputAccessoryView = toolbar
    }
    
    func setupButtons() {
        leakageRateUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        volumeUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
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
    
    var pickerData: [String] = []
    
    // MARK: - Picker
    @IBOutlet weak var picker: UIPickerView!
    
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
    
    func openPicker() {
        picker.isHidden = false
    }
    
    func closePicker() {
        picker.isHidden = true
    }
    
    func setDataDource(source: [String]) {
        self.pickerData = source
        picker.reloadAllComponents()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != picker {
                closePicker()
            }
        }
    }
    
    // MARK: - Calculation
    func createDataSet(airChanges: String, gasLeakage: String, gasLeakageUnits: String, volume: String, volumeUnits: String, timestep: String) -> [(Double, Double)] {
        
        let airChange = Double(airChanges)!
        let Qg = Conversion.Flow().toCubMHour(value: Double(gasLeakage)!, from: Conversion.Flow().getFlowUnits(string: gasLeakageUnits))
        let volume = Conversion.Volume().convertVolume(value: Double(volume)!, from: Conversion.Volume().getUnits(string: volumeUnits))
        let time = Double(timestep)!
        
        //
        
        let Qa = airChange * volume
        
        
        var dataSet: [(time: Double, concentration: Double)] = [(0.0, 0.0)]
        for _ in 0..<100 {
            let time = (dataSet.last!.time + (time / 60))
            let conc = 100 * (Qg / (Qg + Qa)) * (1 - exp(-(Qa + Qg) * time / volume))
            
            let set = (time, conc)
            
            dataSet.append(set)
        }
        
        return dataSet
        
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGraph" {
            if let vc = segue.destination as? GasConcentrationGraphViewController {
                if let data = sender as? [(Double, Double)] {
                    vc.data = data
                }
            }
        }
    }

}
