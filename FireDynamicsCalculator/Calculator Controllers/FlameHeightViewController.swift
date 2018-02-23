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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DataSource
    let length: [String] = ["m", "cm", "ft", "mm", "in"]
    let heat: [String] = ["kW", "Btu / Sec"]
    let area: [String] = ["m²", "ft²", "m²"]
    
    var currentDataSet: [String] = []

    // MARK: - Outlets
    
    @IBOutlet weak var HRR_TF: UITextField!
    @IBOutlet weak var HRR_Units: UIButton!
    
    @IBOutlet weak var diameterTF: UITextField!
    @IBOutlet weak var diameter_Units: UIButton!
    
    @IBOutlet weak var area_TF: UITextField!
    @IBOutlet weak var area_Units: UIButton!
    
    
    
    // MARK: - Buttons
    
    @IBAction func changeHRR_Units(_ sender: Any) {
        currentDataSet = heat
    }
    
    @IBAction func changeDiameter_Units(_ sender: Any) {
        currentDataSet = length
    }
    
    @IBAction func changeArea_Units(_ sender: Any) {
        currentDataSet = area
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
    
    func openPicker() {
        
    }
    
    func closePicker() {
        
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
    
    
}
