//
//  RadiationPoolFireViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 2/27/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit
import SnapKit

class RadiationPoolFireViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDiameterButtons()
        setupPicker()
        setupTextfields()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data Source
    let options: [String] = ["Please Select an Option", "Diameter & Distance", "Length, Width, and Distance"]
    let length: [String] = ["Please Select an Option", "m", "cm", "ft", "mm", "in"]
    let energy: [String] = ["Please Select an Option", "Btu/sec/ft²", "kW/m²"]
    
    var pickerData: [String] = []
    
    // MARK: - Outlets
    var buttonForEditing: UIButton?
    
    @IBOutlet weak var diameterUnits: RoundedButton!
    @IBOutlet weak var distanceUnits: RoundedButton!
    @IBOutlet weak var heatFluxUnits: RoundedButton!
    
    @IBOutlet weak var lengthUnits: RoundedButton!
    @IBOutlet weak var widthUnits: RoundedButton!
    @IBOutlet weak var distanceUnitsLWD: RoundedButton!
    @IBOutlet weak var heatFluxUnitsLWD: RoundedButton!
    
    
    @IBOutlet weak var selectMethodButton: RoundedButton!
    
    @IBOutlet weak var lengthTF: UITextField!
    @IBOutlet weak var widthTF: UITextField!
    @IBOutlet weak var diameter: UITextField!
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var distanceLWD: UITextField!
    
    func setupTextfields() {
        diameter.inputAccessoryView = toolbar
        distance.inputAccessoryView = toolbar
        lengthTF.inputAccessoryView = toolbar
        widthTF.inputAccessoryView = toolbar
        distanceLWD.inputAccessoryView = toolbar
    }
    
    @IBOutlet weak var heatFlux: UILabel!
    @IBOutlet weak var heatFluxLWD: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet var diameterView: UIView!
    @IBOutlet var lengthWidthView: UIView!
    
    
    func setupDiameterButtons() {
        diameterUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        distanceUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        heatFluxUnits.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    }
    
    // MARK: - Buttons
    @IBAction func selectMethod(_ sender: Any) {
        setData(source: options)
        openPicker()
    }
    
    @IBAction func changeDiameterUnits(_ sender: Any) {
        // set picker data source
        setData(source: length)
        buttonForEditing = diameterUnits
        // open picker
        openPicker()
    }
    
    @IBAction func changeDistanceUnits(_ sender: Any) {
        // set picker data source
        setData(source: length)
        if selectMethodButton.titleLabel?.text ==  options[1] {
            buttonForEditing = distanceUnits
        } else {
            buttonForEditing = distanceUnitsLWD
        }
        // open picker
        openPicker()
    }
    
    @IBAction func changeHeatFluxUnits(_ sender: Any) {
        // set picker data source
        setData(source: energy)
        if selectMethodButton.titleLabel?.text ==  options[1] {
            buttonForEditing = heatFluxUnits
        } else {
            buttonForEditing = heatFluxUnitsLWD
        }
        // open picker
        openPicker()
    }
    
    @IBAction func changeLengthUnits(_ sender: Any) {
        setData(source: length)
        buttonForEditing = lengthUnits
        openPicker()
    }
    
    @IBAction func changeWidthUnits(_ sender: Any) {
        setData(source: length)
        buttonForEditing = widthUnits
        openPicker()
    }
    
    @IBAction func calculateResult(_ sender: Any) {
        calculate()
    }
    
    // MARK: - Calculation
    func calculate() {
        let method = selectMethodButton.titleLabel!.text!
        switch method {
        case options[1]:
            guard let diameter = Double(diameter.text!) else { return }
            guard let diamUnits = diameterUnits.titleLabel!.text else { return }
            
            guard let distance = Double(distance.text!) else { return }
            guard let distUnits = distanceUnits.titleLabel!.text else { return }
            
            guard let energyU = heatFluxUnits.titleLabel!.text else { return }
            
            let calculator = RadiationPoolCalculator(energyUnits: energyU)
            let result = calculator.calculatePool(d: diameter, dU: diamUnits,
                                                  dist: distance, distU: distUnits)
            self.heatFlux.text = "\(result)"
        case options[2]:
            guard let distance = Double(distanceLWD.text!) else { return }
            guard let distUnits = distanceUnitsLWD.titleLabel!.text else { return }
            
            guard let length = Double(lengthTF.text!) else { return }
            guard let lengthUnits = lengthUnits.titleLabel!.text else { return }
            
            guard let width = Double(widthTF.text!) else { return }
            guard let widthUnits = widthUnits.titleLabel!.text else { return }
            
            guard let energyU = heatFluxUnitsLWD.titleLabel!.text else { return }
            
            let calculator = RadiationPoolCalculator(energyUnits: energyU)
            let result  = calculator.calculateSquare(dist: distance, distU: distUnits,
                                                     l: length, lU: lengthUnits,
                                                     w: width, wU: widthUnits)
            self.heatFluxLWD.text = "\(result)"
            
        default:
            print("Error calculating")
        }
    }
    
    // MARK: - Actions
    func setData(source: [String]) {
        pickerData = source
        picker.reloadAllComponents()
    }
    
    // Picker DataSource
    func setupPicker() {
        picker.isHidden = true
        picker.delegate = self
        picker.dataSource = self
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

    // DID SELECT ROW
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = pickerData[row]
        if pickerData == options {
            selectMethodButton.setTitle(selected, for: .normal)
            self.closeViewAndPrepare()
            self.openView(option: selected)
            closePicker()
        } else if pickerData == length {
            buttonForEditing!.setTitle(selected, for: .normal)
            closePicker()
        } else if pickerData == energy {
            buttonForEditing!.setTitle(selected, for: .normal)
            closePicker()
        }
    }
    
    func openPicker() {
        picker.selectRow(0, inComponent: 0, animated: false)
        picker.isHidden = false
    }
    
    func closePicker() {
        picker.isHidden = true
    }

    func showSetup(view: UIView) {
        
    }
    
    // External Views
    func openView(option: String) {
        let dd = self.options[1]
        let lwd = self.options[2]
        
        switch option {
        case dd:
            self.view.addSubview(diameterView)
            diameterView.snp.makeConstraints({ (make) in
                make.left.equalToSuperview()
                make.top.equalTo(selectMethodButton).offset(32)
                make.right.equalToSuperview()
                make.height.equalTo(300)
            })
            setupDiameterButtons()
        case lwd:
            self.view.addSubview(lengthWidthView)
            lengthWidthView.snp.makeConstraints({ (make) in
                make.left.equalToSuperview()
                make.top.equalTo(selectMethodButton).offset(32)
                make.right.equalToSuperview()
                make.height.equalTo(300)
            })
        default:
            print("Could not get view")
        }
    }
    
    func closeViewAndPrepare() {
        
        if selectMethodButton.titleLabel?.text == options[1] {
            diameter.text = ""
            distance.text = ""
            
            diameterUnits.setTitle(length[1], for: .normal)
            distanceUnits.setTitle(length[1], for: .normal)
            
            heatFlux.text = "0.0"
            heatFluxUnits.setTitle(energy[1], for: .normal)
            
            diameterView.removeFromSuperview()
        } else if selectMethodButton.titleLabel?.text == options[2] {
            lengthTF.text = ""
            lengthUnits.setTitle(length[1], for: .normal)
            
            widthTF.text = ""
            widthUnits.setTitle(length[1], for: .normal)
            
            distanceLWD.text = ""
            distanceUnitsLWD.setTitle(length[1], for: .normal)
            
            heatFluxLWD.text = "0.0"
            heatFluxUnitsLWD.setTitle(energy[1], for: .normal)
            
            lengthWidthView.removeFromSuperview()
        } else {
            print("No View to close")
        }
    }
    
    // Toolbar
    @IBOutlet var toolbar: UIToolbar!
    @IBAction func closeEditor(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
}

struct RadiationPoolCalculator {
    
    var energyUnits: Conversion.EnergyDensity.EnergyDensity
    init(energyUnits: String) {
        self.energyUnits = Conversion.EnergyDensity().getEnergyDensityUnits(from: energyUnits)
    }
    
    func calculatePool(d: Double, dU: String, dist: Double, distU: String) -> Double {
        let dMeters = Conversion.Length().convertLength(value: d, from: Conversion.Length().getLengthUnits(from: dU))
        let distMeters = Conversion.Length().convertLength(value: dist, from: Conversion.Length().getLengthUnits(from: distU))
        
        let LD = distMeters / dMeters
        
        let heatFluxToTarget = (15.4 * pow(LD, -1.59))
        let HFTT = Conversion.EnergyDensity().convertEnergyDensity(value: heatFluxToTarget, to: energyUnits)
        return HFTT.rounded(toPlaces: 2)
    }
    
    func calculateSquare(dist: Double, distU: String, l: Double, lU: String, w: Double, wU: String) -> Double {
        let distMeters = Conversion.Length().convertLength(value: dist, from: Conversion.Length().getLengthUnits(from: distU))
        
        let lM = Conversion.Length().convertLength(value: l, from: Conversion.Length().getLengthUnits(from: lU))
        let wM = Conversion.Length().convertLength(value: w, from: Conversion.Length().getLengthUnits(from: wU))
        
        let eqDiam = Conversion.Length().convertLength(value: (sqrt(4.0 * lM * wM / Double.pi).rounded(toPlaces: 2)), from: Conversion.Length().getLengthUnits(from: distU))
        
        let LD = distMeters / eqDiam
        
        let heatFluxToTarget = (15.4 * pow(LD, -1.59))
        let HFTT = Conversion.EnergyDensity().convertEnergyDensity(value: heatFluxToTarget, to: energyUnits)
        return HFTT.rounded(toPlaces: 2)
        
    }
}




