//
//  TGasLayerViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/15/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class TGasLayerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

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
    let energy = Conversion.UnitString().energy
    let temperature = Conversion.UnitString().temperature
    let materials = ["Please Select an Option",
                     "Aerated Concrete",
                     "Alumina Silicate Block",
                     "Aluminum (pure)",
                     "Brick",
                     "Brick/Concrete Block",
                     "Calcium Silicate Board",
                     "Chipboard",
                     "Concrete",
                     "Expended Polystyrene",
                     "Fiber Insulation Board",
                     "Glass Fiber Insulation",
                     "Glass Plate",
                     "Gypsum Board",
                     "Plasterboard",
                     "Plywood",
                     "Steel"]
    
    // MARK: - Outlets
    @IBOutlet weak var cwidth: UITextField!
    @IBOutlet weak var clength: UITextField!
    @IBOutlet weak var cheight: UITextField!
    
    @IBOutlet weak var vwidth: UITextField!
    @IBOutlet weak var vheight: UITextField!
    
    @IBOutlet weak var thickness: UITextField!
    @IBOutlet weak var HRR: UITextField!
    @IBOutlet weak var tamb: UITextField!
    
    @IBOutlet weak var lining: UIButton!
    
    @IBOutlet weak var cwUnits: UIButton!
    @IBOutlet weak var clUnits: UIButton!
    @IBOutlet weak var chUnits: UIButton!
    
    @IBOutlet weak var vwUnits: UIButton!
    @IBOutlet weak var vhUnits: UIButton!
    
    @IBOutlet weak var thicknessUnits: UIButton!
    @IBOutlet weak var hrrUnits: UIButton!
    @IBOutlet weak var tambUnits: UIButton!
    
    @IBOutlet weak var tUnits: UIButton!
    
    @IBOutlet weak var TLabel: UILabel!
    
    @IBAction func changeCWUnits(_ sender: Any) {
        buttonForEditing = cwUnits
        setDataSource(source: length)
        openPicker()
    }
    @IBAction func changeCLUnits(_ sender: Any) {
        buttonForEditing = clUnits
        setDataSource(source: length)
        openPicker()
    }
    @IBAction func changeCHUnits(_ sender: Any) {
        buttonForEditing = chUnits
        setDataSource(source: length)
        openPicker()
    }
    
    @IBAction func changeVWUnits(_ sender: Any) {
        buttonForEditing = vwUnits
        setDataSource(source: length)
        openPicker()
    }
    @IBAction func changeVHUnits(_ sender: Any) {
        buttonForEditing = vhUnits
        setDataSource(source: length)
        openPicker()
    }
    
    @IBAction func changeLining(_ sender: Any) {
        buttonForEditing = lining
        setDataSource(source: materials)
        openPicker()
    }
    
    @IBAction func changethicknessUnits(_ sender: Any) {
        buttonForEditing = thicknessUnits
        setDataSource(source: length)
        openPicker()
    }
    @IBAction func changeHRRUnits(_ sender: Any) {
        buttonForEditing = hrrUnits
        setDataSource(source: energy)
        openPicker()
    }
    @IBAction func changeTambUnits(_ sender: Any) {
        buttonForEditing = tambUnits
        setDataSource(source: temperature)
        openPicker()
    }
    
    @IBAction func changeTUnits(_ sender: Any) {
        buttonForEditing = tUnits
        setDataSource(source: temperature)
        openPicker()
    }
    
    @IBAction func calculate(_ sender: Any) {
        calculate()
    }
    
    func calculate() {
        let calc = TGasLayCalculator()
        let result = calc.calculate(cW: cwidth.text!, cWUnits: cwUnits.titleLabel!.text!,
                                    cL: clength.text!, cLUnits: clUnits.titleLabel!.text!,
                                    cH: cheight.text!, cHUnits: chUnits.titleLabel!.text!,
                                    vW: vwidth.text!, vWUnits: vwUnits.titleLabel!.text!,
                                    vH: vheight.text!, vHUnits: vhUnits.titleLabel!.text!,
                                    thickness: thickness.text!, thicknessUnits: thicknessUnits.titleLabel!.text!,
                                    lining: lining.titleLabel!.text!,
                                    Q: HRR.text!, Q_Units: hrrUnits.titleLabel!.text!,
                                    tamb: tamb.text!, tambUnits: tambUnits.titleLabel!.text!,
                                    TUnits: tUnits.titleLabel!.text!)
        
        if let result = result {
            self.TLabel.text = "\(result)"
        } else {
            showAlert(title: "Oops!", message: "Please make sure all fields are filled out.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Setup
    func configure() {
        setupPicker()
        setupButtons()
        setupTextFields()
    }
    
    func setupTextFields() {
        cwidth.inputAccessoryView = toolbar
        clength.inputAccessoryView = toolbar
        cheight.inputAccessoryView = toolbar
        
        vwidth.inputAccessoryView = toolbar
        vheight.inputAccessoryView = toolbar
        
        thickness.inputAccessoryView = toolbar
        HRR.inputAccessoryView = toolbar
        tamb.inputAccessoryView = toolbar
    }
    
    func setupButtons() {
        cwUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        clUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        chUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        
        vwUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        vhUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        
        thicknessUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        hrrUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        tambUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        
        lining.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        tUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
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
    @IBOutlet var picker: UIPickerView!
    
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
        
        buttonForEditing?.setTitle(selected, for: .normal)
        
        if buttonForEditing == tUnits {
            calculate()
        }
    }
    
    func setDataSource(source: [String]) {
        pickerData = source
        picker.reloadAllComponents()
    }
    
    func openPicker() {
        picker.isHidden = false
    }
    
    func closePicker() {
        picker.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != picker {
                closePicker()
            }
        }
    }
    
    // MARK: - Textfields
    
    
    // MARK: - Calculation
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


struct TGasLayCalculator {
    
    func calculate(cW: String, cWUnits: String,
                   cL: String, cLUnits: String,
                   cH: String, cHUnits: String,
                   vW: String, vWUnits: String,
                   vH: String, vHUnits: String,
                   thickness: String, thicknessUnits: String,
                   lining: String,
                   Q: String, Q_Units: String,
                   tamb: String, tambUnits: String,
                   TUnits: String) -> Double? {
        
        
        guard let cw = Double(cW) else { return nil }
        guard let cl = Double(cL) else { return nil  }
        guard let ch = Double(cH) else { return nil  }
        guard let vh = Double(vH) else { return nil  }
        guard let vw = Double(vW) else { return nil  }
        guard let thickness = Double(thickness) else { return nil  }
        guard let q = Double(Q) else { return nil  }
        
        let thicknessConv = Conversion.Length().convertLength(value: thickness, from: Conversion.Length().getLengthUnits(from: thicknessUnits)).rounded(toPlaces: 4)
        let Q_Conv = Conversion.Energy().energy(value: q, from: Conversion.Energy().getEnergyUnits(from: Q_Units))
        let tamb_Conv = Conversion.Temperature().TGasConv(value: tamb, from: Conversion.Temperature().getTemperatureUnits(string: tambUnits)).rounded(toPlaces: 1)
        let thermalConductivity = Conversion.Materials().getMaterialValue(material: Conversion.Materials().getMaterial(material: lining))
        let hk = (thermalConductivity / thicknessConv).rounded(toPlaces: 4)
        
        let vh_Conv = Conversion.Length().convertLength(value: vh, from: Conversion.Length().getLengthUnits(from: vHUnits))
        let vw_Conv = Conversion.Length().convertLength(value: vw, from: Conversion.Length().getLengthUnits(from: vWUnits))
        
        let A0 = (vh_Conv * vw_Conv).rounded(toPlaces: 3)
        
        let cw_Conv = Conversion.Length().convertLength(value: cw, from: Conversion.Length().getLengthUnits(from: cWUnits))
        let ch_Conv = Conversion.Length().convertLength(value: ch, from: Conversion.Length().getLengthUnits(from: cHUnits))
        let cl_Conv = Conversion.Length().convertLength(value: cl, from: Conversion.Length().getLengthUnits(from: cLUnits))
        
        let AT = ((2 * (cw_Conv * cl_Conv) + 2 * (ch_Conv * cw_Conv) + 2 * (ch_Conv * cl_Conv)) - A0).rounded(toPlaces: 1)
        
        let Ho = vh_Conv
        
        let p1 = 6.85
        let p2 = ((pow(Q_Conv, 2.0)) / (A0 * sqrt(Ho) * hk * AT))
        let p3 = pow(p2, (1/3))
        
        let Tk = (p1 * p3 + tamb_Conv).rounded(toPlaces: 0)
        let T = Conversion.Temperature().TGasConv(value: "\(Tk)", from: Conversion.Temperature().getTemperatureUnits(string: TUnits))
        
        return T.rounded(toPlaces: 1)
        
    }
}
