//
//  SolidIgnitionViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/5/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class SolidIgnitionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, PickerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    let options = ["Thermally Thin", "Thermally Thick", "Thermally Thick with Materials"]
    @IBOutlet weak var methodSelectionButton: UIButton!
    @IBAction func selectMethod(_ sender: Any) {
        pickerData = options
        openPicker()
    }
    
    @IBOutlet var thermallyThinUIView: ThermallyThinView!
    
    func open(view: UIView) {
        if view == thermallyThinUIView {
            thermallyThinUIView.pickerDelegate = self
        }
        
        self.view.addSubview(view)
        view.center = self.view.center
    }
    
    
    
    
    var responderDelegate: PickerResponderDelegate?
    
    // Data
    let density: [String] = ["Please Select an Option", "kg/m³", "lb/ft³"]
    let length: [String] = ["Please Select an Option", "m", "cm", "ft", "mm", "in"]
    let temperature: [String] = ["Please Select an Option", "°C","°F","K","R"]
    let energy: [String] = ["Please Select an Option", "Btu/sec/ft²", "kW/m²"]
    let materials: [String] = ["Please Select an Option", "Air", "Asbestos", "Brick", "Concrete High", "Concrete Low", "Copper", "Fiber Insulating Board", "Glass Plate", "Gypsum Plaster", "Oak", "PMMA", "Polyurethane Foam", "Steel Mild", "Yellow Pine"]
    let time: [String] = ["Please Select an Option", "Hr", "Min", "Sec"]
    
    // MARK: Picker
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
        let selection = pickerData[row]
        
        if pickerData != options {
            responderDelegate?.didSelectOption(option: selection)
        } else {
            if selection == options[0] {
                self.open(view: thermallyThinUIView)
            } else if selection == options[1] {
                
            } else if selection == options[2] {
                
            }
        }
        closePicker()
    }

    func setDataSource(dataSet: Conversion.Units.List) {
        switch dataSet {
        case .Density:
            self.pickerData = self.density
        case .Length:
            self.pickerData = self.length
        case .Temperature:
            self.pickerData = self.temperature
        case .Energy:
            self.pickerData = self.energy
        case .Materials:
            self.pickerData = self.materials
        case .Time:
            self.pickerData = self.time
        default:
            print("Error Setting data")
        }
        
        openPicker()
    }
    
    func openPicker() {
        // set picker to 0
        // set to not hidden
    }
    
    func closePicker() {
        
    }
    

}

protocol PickerResponderDelegate {
    func didSelectOption(option: String)
}

struct SolidIgnitionCalculator {
    
    func thermallyThin(density: String, densityUnits: String,
                       specificHeat: String,
                       thickness: String, thicknessUnits: String,
                       TIG: String, TIGUnits: String,
                       TAMB: String, TAMBUnits: String,
                       heatFlux: String, heatFluxUnits: String) -> Double {
        
        let density = Conversion.Density().convertDensity(value: Double(density)!, from: Conversion.Density().getDensityUnits(from: densityUnits))
        let specificHeat = Double(specificHeat)!
        let thickness = Conversion.Length().convertLength(value: Double(thickness)!, from: Conversion.Length().getLengthUnits(from: thicknessUnits))
        let TIG = Conversion.Temperature().convertTemperature(value: TIG, from: Conversion.Temperature().getTemperatureUnits(string: TIGUnits))
        let TAMB = Conversion.Temperature().convertTemperature(value: TAMB, from: Conversion.Temperature().getTemperatureUnits(string: TAMBUnits))
        let heatFlux = Conversion.EnergyDensity().convertEnergyDensity(value: Double(heatFlux)!, to: Conversion.EnergyDensity().getEnergyDensityUnits(from: heatFluxUnits))
        
        
        let p1 = density * specificHeat * thickness
        let p2 = TIG - TAMB
        let result = (p1 * p2 / heatFlux).rounded(toPlaces: 2)
        
        return result
        
    }
    
    func thermallyThick(c: String,
                        density: String, densityUnits: String,
                        specificHeat: String,
                        thermalConductivity: String,
                        TIG: String, TIGUnits: String,
                        TAMB: String, TAMBUnits: String,
                        heatFlux: String, heatFluxUnits: String) -> Double {
        
        let c = Double(c)!
        let density = Conversion.Density().convertDensity(value: Double(density)!, from: Conversion.Density().getDensityUnits(from: densityUnits))
        let specificHeat = Double(specificHeat)!
        let thermalConductivity = Double(thermalConductivity)!
        let TIG = Conversion.Temperature().convertTemperature(value: TIG, from: Conversion.Temperature().getTemperatureUnits(string: TIGUnits))
        let TAMB = Conversion.Temperature().convertTemperature(value: TAMB, from: Conversion.Temperature().getTemperatureUnits(string: TAMBUnits))
        let heatFlux = Conversion.EnergyDensity().convertEnergyDensity(value: Double(heatFlux)!, to: Conversion.EnergyDensity().getEnergyDensityUnits(from: heatFluxUnits))
        
        
        let p1 = c * thermalConductivity * density * specificHeat
        let p2 = ((TIG - TAMB) / (heatFlux))
        let result = (p1 * pow(p2, 2.0)).rounded(toPlaces: 2)
        return result
        
    }
    
    func thermallyThick(withMaterial: String, c: String, TAMB: String, TAMBUnits: String, heatFlux: String, heatFluxUnits: String) -> String {
        if let material =  materials[withMaterial] {
            let c = Double(c)!
            let kpc = material["kpc"]!
            let tig = material["Tig"]!
            let critig = material["crit q"]!
            let heatFlux = Conversion.EnergyDensity().convertEnergyDensity(value: Double(heatFlux)!, to: Conversion.EnergyDensity().getEnergyDensityUnits(from: heatFluxUnits))
            let TAMB = Conversion.Temperature().convertTemperature(value: TAMB, from: Conversion.Temperature().getTemperatureUnits(string: TAMBUnits))
            
            if heatFlux > critig {
                let p1 = c * kpc
                let p2 = (tig - TAMB) / heatFlux
                let p3 = pow(p2, 2.0)
                let result = (p1 * p3).rounded(toPlaces: 2)
                return "\(result)"
            } else {
                return "Below Critial Flux"
            }
        } else {
            return "ERROR"
        }
    }
    
    
    // helper
    
    let materials = ["Aircraft panel, epoxy fiberite": ["kpc": 0.24, "Tig": 505, "crit q": 28],
                     "Asphalt shingle": ["kpc": 0.7, "Tig": 378, "crit q": 15],
                     "Carpet (acrylic)": ["kpc": 0.42, "Tig": 300, "crit q": 10],
                     "Carpet (nylon/wool blend)": ["kpc": 0.68, "Tig": 412, "crit q": 18],
                     "Carpet (wool, stock)": ["kpc": 0.11, "Tig": 465, "crit q": 23],
                     "Carpet (wool, treated)": ["kpc": 0.24, "Tig": 455, "crit q": 22],
                     "Carpet (wool, untreated)": ["kpc": 0.25, "Tig": 435, "crit q": 20],
                     "Douglas Fir particleboard (1.27cm)": ["kpc": 0.94, "Tig": 382, "crit q": 16],
                     "Fiber insulation board": ["kpc": 0.46, "Tig": 355, "crit q": 14],
                     "Fiberglass shingle": ["kpc": 0.5, "Tig": 445, "crit q": 21],
                     "Foam, flexible (2.54cm)": ["kpc": 0.32, "Tig": 390, "crit q": 16],
                     "Foam, rigid (2.54cm)": ["kpc": 0.03, "Tig": 435, "crit q": 20],
                     "Glass reinforced polyester (1.14mm)": ["kpc": 0.72, "Tig": 400, "crit q": 17],
                     "Glass reinforced polyester (2.24mm)": ["kpc": 0.32, "Tig": 390, "crit q": 16],
                     "Hardboard (3.175mm)": ["kpc": 0.88, "Tig": 365, "crit q": 14],
                     "Hardboard (6.35mm)": ["kpc": 1.87, "Tig": 298, "crit q": 10],
                     "Hardboard, gloss paint (3.4mm)": ["kpc": 1.22, "Tig": 400, "crit q": 17],
                     "Hardboard, nitrocellulose paint)": ["kpc": 0.79, "Tig": 400, "crit q": 17],
                     "Particleboard (1.27cm)": ["kpc": 0.93, "Tig": 412, "crit q": 18],
                     "Plywood, FR (1.27 cm)": ["kpc": 0.76, "Tig": 620, "crit q": 44],
                     "Plywood, plain (0.635 cm)": ["kpc": 0.46, "Tig": 390, "crit q": 16],
                     "Plywood, plain (1.27 cm)": ["kpc": 0.54, "Tig": 390, "crit q": 16],
                     "PMMA polycast (1.599mm)": ["kpc": 0.73, "Tig": 278, "crit q": 9],
                     "PMMA type G (1.27cm)": ["kpc": 1.02, "Tig": 378, "crit q": 15],
                     "Polycarbonate (1.52mm)": ["kpc": 1.16, "Tig": 528, "crit q": 30],
                     "Polyisocyanurate (5.08cm)": ["kpc": 0.02, "Tig": 445, "crit q": 21],
                     "Polystyrene (5.08cm)": ["kpc": 0.38, "Tig": 630, "crit q": 46]]
}
