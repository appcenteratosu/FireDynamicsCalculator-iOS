//
//  RadiationPoolFireViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 2/27/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class RadiationPoolFireViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        
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
    @IBOutlet weak var diameterUnits: RoundedButton!
    @IBOutlet weak var distanceUnits: RoundedButton!
    @IBOutlet weak var heatFluxUnits: RoundedButton!
    
    @IBOutlet weak var selectMethodButton: RoundedButton!
    
    @IBOutlet weak var diameter: UITextField!
    @IBOutlet weak var distance: UITextField!
    
    @IBOutlet weak var heatFlux: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet var diameterView: UIView!
    
    
    func setupButtons() {
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
        // open picker
        openPicker()
    }
    
    @IBAction func changeDistanceUnits(_ sender: Any) {
        // set picker data source
        setData(source: length)
        // open picker
        openPicker()
    }
    
    @IBAction func changeHeatFluxUnits(_ sender: Any) {
        // set picker data source
        setData(source: energy)
        // open picker
        openPicker()
    }
    
    // MARK: - Actions
    func setData(source: [String]) {
        pickerData = source
        picker.reloadAllComponents()
    }
    
    // Picker DataSource
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
        if pickerData == options {
            let selected = pickerData[row]
            selectMethodButton.setTitle(selected, for: .normal)
            
        } else if pickerData == length {
            
        } else if pickerData == energy {
            
        }
    }
    
    func openPicker() {
        picker.isHidden = false
    }
    
    func closePicker() {
        picker.isHidden = true
    }

    func showSetup(view: UIView) {
        
    }
    
    
}

struct RadiationPoolCalculator {
    
    var energyUnits: Conversion.Units.EnergyDensity
    init(energyUnits: String) {
        self.energyUnits = Conversion().getEnergyDensityUnits(from: energyUnits)
    }
    
    func calculatePool(d: Double, dU: String, dist: Double, distU: String) -> Double {
        let dMeters = Conversion().length(value: d, from: Conversion().getLengthUnits(from: dU))
        let distMeters = Conversion().length(value: dist, from: Conversion().getLengthUnits(from: distU))
        
        let LD = distMeters / dMeters
        
        let heatFluxToTarget = (15.4 * pow(LD, -1.59))
        let HFTT = Conversion().energyDensity(value: heatFluxToTarget, to: energyUnits)
        return HFTT.rounded(toPlaces: 2)
    }
    
    func calculateSquare(dist: Double, distU: String, l: Double, lU: String, w: Double, wU: String) -> Double {
        let distMeters = Conversion().length(value: dist, from: Conversion().getLengthUnits(from: distU))
        
        let lM = Conversion().length(value: l, from: Conversion().getLengthUnits(from: lU))
        let wM = Conversion().length(value: w, from: Conversion().getLengthUnits(from: wU))
        
        let eqDiam = Conversion().length(value: (sqrt(4.0 * lM * wM / Double.pi).rounded(toPlaces: 2)), from: Conversion().getLengthUnits(from: distU))
        
        let LD = distMeters / eqDiam
        
        let heatFluxToTarget = (15.4 * pow(LD, -1.59))
        let HFTT = Conversion().energyDensity(value: heatFluxToTarget, to: energyUnits)
        return HFTT.rounded(toPlaces: 2)
        
    }
}




