//
//  OxygenLevelsViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/15/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class OxygenLevelsViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
    let length = Conversion.UnitString().length
    let growthRates = ["Please select and option", "Slow", "Medium", "Fast", "Ultrafast"]
    
    func setDataSource(source: [String]) {
        pickerData = source
        picker.reloadAllComponents()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var rWidth: UITextField!
    @IBOutlet weak var rLength: UITextField!
    @IBOutlet weak var rHeight: UITextField!
    
    @IBOutlet weak var rWidthUnits: UIButton!
    @IBOutlet weak var rrLengthUnits: UIButton!
    @IBOutlet weak var rHeightUnits: UIButton!
    
    @IBAction func changeWidthUnits(_ sender: Any) {
        buttonForEditing = rWidthUnits
        setDataSource(source: length)
        openPicker()
    }
    
    @IBAction func changeLengthUnits(_ sender: Any) {
        buttonForEditing = rrLengthUnits
        setDataSource(source: length)
        openPicker()
    }
    
    @IBAction func changeHeightUnits(_ sender: Any) {
        buttonForEditing = rHeightUnits
        setDataSource(source: length)
        openPicker()
    }
    
    @IBOutlet weak var initOx_Perc: UITextField!
    @IBOutlet weak var hrr: UITextField!
    
    @IBOutlet weak var t2Growthrate: UIButton!
    @IBAction func chagenGrowthRate(_ sender: Any) {
        buttonForEditing = t2Growthrate
        setDataSource(source: growthRates)
        openPicker()
    }
    
    @IBOutlet weak var timestep: UITextField!
    
    
    // MARK: - Setup
    func configure() {
        setupBackground()
        setupButtons()
        setupTextFields()
        setupPicker()
        setupCard()
    }
    
    func setupTextFields() {
        rWidth.inputAccessoryView = toolbar
        rLength.inputAccessoryView = toolbar
        rHeight.inputAccessoryView = toolbar
        initOx_Perc.inputAccessoryView = toolbar
        hrr.inputAccessoryView = toolbar
        timestep.inputAccessoryView = toolbar
    }
    
    func setupButtons() {
        rWidthUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        rrLengthUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        rHeightUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        t2Growthrate.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    }
    
    func setupPicker() {
        picker.delegate = self
        picker.dataSource = self
    }
    
    @IBOutlet weak var cardView: UIView!
    func setupCard() {
        cardView.layer.cornerRadius = 5
    }
    
    // MARK: - Toolbar
    @IBOutlet var toolbar: UIToolbar!
    @IBAction func endEditingButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // MARK: - Picker
    var pickerData: [String] = []
    @IBOutlet var picker: UIPickerView!
    
    var buttonForEditing: UIButton?
    
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
        self.view.addSubview(picker)
        picker.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(160)
        }
        picker.selectRow(0, inComponent: 0, animated: true)
    }
    
    func closePicker() {
        picker.snp.removeConstraints()
        picker.removeFromSuperview()
    }
    
    // MARK: - Calculation
    @IBOutlet weak var calculate: RoundedButton!
    @IBAction func calculate(_ sender: Any) {
        let calc = OxygenLevelsCalculator()
        let results = calc.calculate(width: rWidth.text!, wUnits: rWidthUnits.titleLabel!.text!,
                                     length: rLength.text!, lUnits: rrLengthUnits.titleLabel!.text!,
                                     height: rHeight.text!, hUnits: rHeightUnits.titleLabel!.text!,
                                     initO2: initOx_Perc.text!,
                                     hrr: hrr.text!,
                                     growthRate: t2Growthrate.titleLabel!.text!,
                                     timeStep: timestep.text!)
        self.performSegue(withIdentifier: "ShowResults", sender: results)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != picker {
                closePicker()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResults" {
            if let vc = segue.destination as? OxygenLevelsResultsViewController {
                if let results = sender as? (Double, [[String: Double]]) {
                    vc.results = results
                    
                } else {
                    showAlert(title: "Oops!", message: "Please make sure to provide a value for each field")
                }
            }
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

}

struct OxygenLevelsCalculator {
    
    
    
    func calculate(width: String, wUnits: String,
                   length: String, lUnits: String,
                   height: String, hUnits: String,
                   initO2: String,
                   hrr: String,
                   growthRate: String,
                   timeStep: String) -> (TT14: Double?, dataset: [[String: Double]]?) {
        
        // pt 1
        guard width != "" else { return (nil, nil) }
        guard length != "" else { return (nil, nil) }
        guard height != "" else { return (nil, nil) }
        
        let w = Conversion.Length().convertLength(value: Double(width)!, from: Conversion.Length().getLengthUnits(from: wUnits))
        let l = Conversion.Length().convertLength(value: Double(length)!, from: Conversion.Length().getLengthUnits(from: lUnits))
        let h = Conversion.Length().convertLength(value: Double(height)!, from: Conversion.Length().getLengthUnits(from: hUnits))
        
        let volume = w * l * h
        
        // pt 2
        guard let initO2 = Double(initO2) else { return (nil, nil) }
        let o2p = initO2 / 100
        
        let O2MolecularWeight = 32.0
        let MolarMass = o2p * O2MolecularWeight
        let o2_cubM = 1000 / 22.4 * MolarMass / 1000
        
        let initWeightOfO2 = o2_cubM * volume
        
        
        // pt 3
        
        let kJ_kgO2 = 13.1 * 1000
        
        guard let hrr = Double(hrr) else  { return (nil, nil) }
        
        let timeToReduce1 = ((((initWeightOfO2 / o2p) / 100) * kJ_kgO2) / hrr).rounded(toPlaces: 2)
        let timeToReduceTo14 = ((o2p - 0.14) * 100 * timeToReduce1).rounded(toPlaces: 0)
        
        // pt 4
        
        let values = ["Fast": [150.0, 0.044], "Medium": [300.0, 0.011], "Slow": [600.0, 0.003], "Ultrafast": [75.0, 0.178]]
        let growthRt = values[growthRate]!
        let alpha = growthRt[1]
        
        guard let timestep = Double(timeStep) else { return (nil, nil) }
        
        let dataSet = createDataSet(timstep: timestep, alpha: alpha, kJ_O2Cons: kJ_kgO2, initWeightO2: initWeightOfO2, initOX: initO2)
        
        
        return (timeToReduceTo14, dataSet)
    }
    
    private func createDataSet(timstep: Double, alpha: Double, kJ_O2Cons: Double, initWeightO2: Double, initOX: Double) -> [[String: Double]] {
        
        var times: [Double] = [0.0]
        for i in 1..<50 {
            let newTimeEntry = times.last! + timstep
            times.append(newTimeEntry)
        }
        
        var HRRs: [Double] = [0.0]
        for i in 1..<50 {
            let newHrrEntry = alpha * pow(times[i], 2.0)
            HRRs.append(newHrrEntry.rounded(toPlaces: 2))
        }
        
        var energys: [Double] = [0.0]
        for i in 1..<50 {
            let newEnergyEntry = HRRs[i] * (times[i] - times[i-1]) + energys[i-1]
            energys.append(newEnergyEntry)
        }
        
        var O2s: [Double] = [0.0]
        for i in 1..<50 {
            let newO2Entry = energys[i] / kJ_O2Cons
            O2s.append(newO2Entry)
        }
        
        var percentO2InRoom: [Double] = [0.0]
        for i in 1..<50 {
            let newO2Entry = (initWeightO2 - O2s[i]) / (initWeightO2 / initOX)
            percentO2InRoom.append(newO2Entry)
        }
        
        var dataSet: [[String: Double]] = [[:]]
        
        for i in 0..<50 {
            if percentO2InRoom[i] >= 0.0 {
                let set = ["time": times[i].rounded(toPlaces: 0),
                           "HRR": HRRs[i].rounded(toPlaces: 4),
                           "energy": energys[i].rounded(toPlaces: 4),
                           "O2Cons": O2s[i].rounded(toPlaces: 4),
                           "%O2": percentO2InRoom[i].rounded(toPlaces: 4)]
                dataSet.append(set)
            }
        }
        
        
        return dataSet
        
        
    }
    
    
    
}






















