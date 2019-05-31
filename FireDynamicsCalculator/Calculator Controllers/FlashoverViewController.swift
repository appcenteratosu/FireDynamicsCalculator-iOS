//
//  FlashoverViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 1/21/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit
import SnapKit

class FlashoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeyboard()
        setupPicker()
        defaultLabels()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlets
    // Textfields
    @IBOutlet weak var widthTF: UITextField!
    @IBOutlet weak var lengthTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var vWidthTF: UITextField!
    @IBOutlet weak var vHeightTF: UITextField!
    @IBOutlet weak var thickness: UITextField!
    
    func emptyTFExists() -> Bool {
        guard widthTF.text!.count > 0 else { return true }
        guard lengthTF.text!.count > 0 else { return true }
        guard heightTF.text!.count > 0 else { return true }
        guard vWidthTF.text!.count > 0 else { return true }
        guard vHeightTF.text!.count > 0 else { return true }
        guard thickness.text!.count > 0 else { return true }
        guard liningButton.titleLabel!.text != "Material" else { return true }
        
        return false
    }
    
    // MARK: - Buttons
    @IBOutlet weak var widthButton: RoundedButton!
    @IBOutlet weak var lengthButton: RoundedButton!
    @IBOutlet weak var heightButton: RoundedButton!
    @IBOutlet weak var ventWidthButton: RoundedButton!
    @IBOutlet weak var ventHeightButton: RoundedButton!
    @IBOutlet weak var thicknessButton: RoundedButton!
    
    @IBOutlet weak var liningButton: RoundedButton!
    var lining: String = ""
    
    @IBOutlet weak var mkhButton: RoundedButton!
    @IBOutlet weak var babraukasButton: RoundedButton!
    @IBOutlet weak var thomasButton: RoundedButton!
    
    
    // MARK: - Methods
    @IBAction func selectMeasureUnit(_ sender: UIButton) {
        setDataSource(data: lengths)
        self.showPicker(tag: sender.tag)
    }
    
    @IBAction func selectMaterial(_ sender: UIButton) {
        self.view.endEditing(true)
        let options = materials.toStringArray()
        let ops = options.sorted()
        setDataSource(data: ops)
        self.showPicker(tag: sender.tag)
    }
    
    @IBAction func selectFinalUnits(_ sender: UIButton) {
        setDataSource(data: finalUnits)
        self.showPicker(tag: sender.tag)
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        
        calculate()
        
    }
    
    // MARK: - Labels
    @IBOutlet weak var mqhLabel: UILabel!
    @IBOutlet weak var babrLabel: UILabel!
    @IBOutlet weak var tomLabel: UILabel!
    
    
    // MARK: - Calculations
    var mqh: Double = 0.0
    var babr: Double = 0.0
    var tom: Double = 0.0
    
    func calculate() {
        if emptyTFExists() {
            
        } else {
            
            let length = Double(lengthTF.text!)!
            let width = Double(widthTF.text!)!
            let height = Double(heightTF.text!)!
            let vwidth = Double(vWidthTF.text!)!
            let vheight = Double(vHeightTF.text!)!
            let thicknes = Double(thickness.text!)!
            let material = lining
            
            let mqh = MQH(a: AreaMeasures(l: MeasureSet(measure: length, units: getLength(button: lengthButton)),
                                          w: MeasureSet(measure: width, units: getLength(button: widthButton)),
                                          h: MeasureSet(measure: height, units: getLength(button: heightButton))),
                          v: VentMeasures(vW: MeasureSet(measure: vwidth, units: getLength(button: ventWidthButton)),
                                          vH: MeasureSet(measure: vheight, units: getLength(button: ventHeightButton))),
                          t: MeasureSet(measure: thicknes, units: getLength(button: thicknessButton)),
                          m: getMaterial(material: material))
            
            let babr = Babrauskas(a: AreaMeasures(l: MeasureSet(measure: length, units: getLength(button: lengthButton)),
                                                  w: MeasureSet(measure: width, units: getLength(button: widthButton)),
                                                  h: MeasureSet(measure: height, units: getLength(button: heightButton))),
                                  v: VentMeasures(vW: MeasureSet(measure: vwidth, units: getLength(button: ventWidthButton)),
                                                  vH: MeasureSet(measure: vheight, units: getLength(button: ventHeightButton))),
                                  t: MeasureSet(measure: thicknes, units: getLength(button: thicknessButton)),
                                  m: getMaterial(material: material))
            
            let tom = Thomas(a: AreaMeasures(l: MeasureSet(measure: length, units: getLength(button: lengthButton)),
                                             w: MeasureSet(measure: width, units: getLength(button: widthButton)),
                                             h: MeasureSet(measure: height, units: getLength(button: heightButton))),
                             v: VentMeasures(vW: MeasureSet(measure: vwidth, units: getLength(button: ventWidthButton)),
                                             vH: MeasureSet(measure: vheight, units: getLength(button: ventHeightButton))),
                             t: MeasureSet(measure: thicknes, units: getLength(button: thicknessButton)),
                             m: getMaterial(material: material))
            
            let rMQH = Conversion.Energy().energy(value: mqh, from: .kW)
            let rBABR = Conversion.Energy().energy(value: babr, from: .kW)
            let rTOM = Conversion.Energy().energy(value: tom, from: .kW)
            
            
            self.mqh = rMQH.rounded(toPlaces: 2)
            self.babr = rBABR.rounded(toPlaces: 2)
            self.tom = rTOM.rounded(toPlaces: 2)
            
            self.mqhLabel.text = "\(self.mqh)"
            self.babrLabel.text = "\(self.babr)"
            self.tomLabel.text = "\(self.tom)"
        }
    }
    
    func getLength(button: UIButton) -> Conversion.Length.Length {
        switch button.titleLabel!.text! {
        case "cm":
            return .cm
        case "feet":
            return .feet
        case "inches":
            return .inches
        case "meters":
            return .meters
        case "mm":
            return .mm
        default:
            return .cm
        }
    }
    
    func getEnergy(buttonTitle: String) -> Conversion.Units.Energy {
        switch buttonTitle {
        case "kW":
            return .kW
        case "Btu / sec":
            return .BtuSec
        default:
            return .kW
        }
    }
    
    func getMaterial(material: String) -> Conversion.Materials.material {
        switch material {
        case "Aerated Concrete":
            return .AeratedConcrete
        case "Alumina Silicate Block":
            return .AluminaSilicateBlock
        case "Aluminum":
            return .Aluminum
        case "Brick":
            return .Brick
        case "Brick/Concrete Block":
            return .BrickConcreteBlock
        case "Calcium Silicate Board ":
            return .CalciumSilicateBoard
        case "Chipboard":
            return .Chipboard
        case "Concrete":
            return .Concrete
        case "Expended Polystyrene":
            return .ExpendedPolystyrene
        case "Fiber Insulation Board":
            return .FiberInsulationBoard
        case "Glass Fiber Insulation":
            return .GlassFiberInsulation
        case "Glass Plate":
            return .GlassPlate
        case "Gypsum Board":
            return .GypsumBoard
        case "Plasterboard":
            return .Plasterboard
        case "Plywood":
            return .Plywood
        case "Steel":
            return .Steel
        default:
            return .GypsumBoard
        }
    }
    
    // MARK: - Setup Things
    func setupKeyboard() {
        widthTF.delegate = self
        lengthTF.delegate = self
        heightTF.delegate = self
        vWidthTF.delegate = self
        vHeightTF.delegate = self
        thickness.delegate = self
        
        widthTF.inputAccessoryView = toolbar
        lengthTF.inputAccessoryView = toolbar
        heightTF.inputAccessoryView = toolbar
        vWidthTF.inputAccessoryView = toolbar
        vHeightTF.inputAccessoryView = toolbar
        thickness.inputAccessoryView = toolbar
    }
    
    func setupPicker() {
        picker.isHidden = true
//        picker.backgroundColor = UIColor.lightGray
        picker.selectRow(0, inComponent: 0, animated: false)
        picker.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    func defaultLabels() {
        mqhLabel.text = ""
        babrLabel.text = ""
        tomLabel.text = ""
    }
    
    @IBOutlet var toolbar: UIToolbar!
    @IBAction func closeKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - PickerView
    @IBOutlet var picker: UIPickerView!
    var pickerItems: [String] = []
    var lengths = ["Please Select a Value", "cm", "feet", "inches", "meters", "mm"]
    var materials = ["* Please Select an Option *": 0.0,
                     "Aerated Concrete": 0.00026,
                     "Alumina Silicate Block": 0.00014,
                     "Aluminum (pure)": 0.206,
                     "Brick": 0.0008,
                     "Brick/Concrete Block": 0.00073,
                     "Calcium Silicate Board": 0.00013,
                     "Chipboard": 0.00015,
                     "Concrete": 0.0016,
                     "Expended Polystyrene": 0.000034,
                     "Fiber Insulation Board": 0.00053,
                     "Glass Fiber Insulation": 0.000037,
                     "Glass Plate": 0.00076,
                     "Gypsum Board": 0.00017,
                     "Plasterboard": 0.00016,
                     "Plywood": 0.00012,
                     "Steel": 0.054]
    var finalUnits = ["Please Select a Value", "kW", "Btu / sec"]
    
    func setDataSource(data: [String]) {
        pickerItems = data
        picker.reloadAllComponents()
    }
    
    var buttonForEditing: UIButton?
    func showPicker(tag: Int) {
        switch tag {
        case 1:
            buttonForEditing = widthButton
        case 2:
            buttonForEditing = lengthButton
        case 3:
            buttonForEditing = heightButton
        case 4:
            buttonForEditing = ventWidthButton
        case 5:
            buttonForEditing = ventHeightButton
        case 6:
            buttonForEditing = thicknessButton
        case 7:
            buttonForEditing = liningButton
        case 8:
            buttonForEditing = mkhButton
        case 9:
            buttonForEditing = babraukasButton
        case 10:
            buttonForEditing = thomasButton
        default:
            buttonForEditing = widthButton
        }
        
        picker.isHidden = false
        
    }
    
    func hidePicker() {
        self.picker.isHidden = true
    }
    
    // MARK: - Calculation

    func MQH(a: AreaMeasures, v: VentMeasures, t: MeasureSet, m: Conversion.Materials.material) -> Double {
        let cw = Conversion.Length().convertLength(value: a.w.measure, from: a.w.units)
        let cl = Conversion.Length().convertLength(value: a.l.measure, from: a.l.units)
        let ch = Conversion.Length().convertLength(value: a.h.measure, from: a.h.units)
        let vw = Conversion.Length().convertLength(value: v.vW.measure, from: v.vW.units)
        let vh = Conversion.Length().convertLength(value: v.vH.measure, from: v.vH.units)
        let thickness = Conversion.Length().convertLength(value: t.measure, from: t.units)
        let thermalConductivity = Conversion.Materials().getMaterialValue(material: m)
        
        let hk = thermalConductivity / thickness
        let Av = (vw * vh)
        let AT = (2 * (cw * cl)) + (2 * (ch * cw)) + (2 * (cl * ch)) - Av
        
        let sqVhm = vh.squareRoot()
        let sqtot = (hk * AT * Av * sqVhm)
        let q = (610 * sqtot.squareRoot())
        
        return q.rounded()
    }
    
    func Babrauskas(a: AreaMeasures, v: VentMeasures, t: MeasureSet, m: Conversion.Materials.material) -> Double {
        let cw = Conversion.Length().convertLength(value: a.w.measure, from: a.w.units)
        let cl = Conversion.Length().convertLength(value: a.l.measure, from: a.l.units)
        let ch = Conversion.Length().convertLength(value: a.h.measure, from: a.h.units)
        let vw = Conversion.Length().convertLength(value: v.vW.measure, from: v.vW.units)
        let vh = Conversion.Length().convertLength(value: v.vH.measure, from: v.vH.units)
        let thickness = Conversion.Length().convertLength(value: t.measure, from: t.units)
        let thermalConductivity = Conversion.Materials().getMaterialValue(material: m)
        
        let hk = thermalConductivity / thickness
        let Av = (vw * vh)
        let AT = (2 * (cw * cl)) + (2 * (ch * cw)) + (2 * (cl * ch)) - Av
        
        let sqVhm = vh.squareRoot()
        let q = (750 * Av * sqVhm)
        
        return q.rounded()
    }
    
    func Thomas(a: AreaMeasures, v: VentMeasures, t: MeasureSet, m: Conversion.Materials.material) -> Double {
        let cw = Conversion.Length().convertLength(value: a.w.measure, from: a.w.units)
        let cl = Conversion.Length().convertLength(value: a.l.measure, from: a.l.units)
        let ch = Conversion.Length().convertLength(value: a.h.measure, from: a.h.units)
        let vw = Conversion.Length().convertLength(value: v.vW.measure, from: v.vW.units)
        let vh = Conversion.Length().convertLength(value: v.vH.measure, from: v.vH.units)
        let thickness = Conversion.Length().convertLength(value: t.measure, from: t.units)
        let thermalConductivity = Conversion.Materials().getMaterialValue(material: m)
        
        let hk = thermalConductivity / thickness
        let Av = (vw * vh)
        let AT = (2 * (cw * cl)) + (2 * (ch * cw)) + (2 * (cl * ch)) - Av
        
        let sqVhm = vh.squareRoot()
        let q = ((7.8 * AT) + (378 * Av * sqVhm))
        
        return q.rounded()
    }
    

}

extension FlashoverViewController {
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
        buttonForEditing?.setTitle(pickerItems[row], for: .normal)
        hidePicker()
        if buttonForEditing == liningButton {
            let line = pickerItems[row]
            self.lining = line
            calculate()
        } else if buttonForEditing == mkhButton {
            let value = Conversion.Energy().energy(value: Double(self.mqh), from: getEnergy(buttonTitle: pickerItems[row]))
            let rValue = Int(value.rounded())
            mqhLabel.text = "\(rValue)"
        } else if buttonForEditing == babraukasButton {
            let value = Conversion.Energy().energy(value: Double(self.babr), from: getEnergy(buttonTitle: pickerItems[row]))
            let rValue = Int(value.rounded())
            babrLabel.text = "\(rValue)"
        } else if buttonForEditing == thomasButton {
            let value = Conversion.Energy().energy(value: Double(self.tom), from: getEnergy(buttonTitle: pickerItems[row]))
            let rValue = Int(value.rounded())
            tomLabel.text = "\(rValue)"
        }
    }
}

extension Dictionary where Key == String {
    func toStringArray() -> [String] {
        var stringKeys: [String] = []
        for key in keys {
            stringKeys.append(key)
        }
        return stringKeys
    }
}

struct MeasureSet {
    let measure: Double
    let units: Conversion.Length.Length
    
    init(measure: Double, units: Conversion.Length.Length) {
        self.measure = measure
        self.units = units
    }
}

struct AreaMeasures {
    let l: MeasureSet
    let w: MeasureSet
    let h: MeasureSet
    
    init(l: MeasureSet, w: MeasureSet, h: MeasureSet) {
        self.l = l
        self.w = w
        self.h = h
    }
}

struct VentMeasures {
    let vW: MeasureSet
    let vH: MeasureSet
    
    init(vW: MeasureSet, vH: MeasureSet) {
        self.vW = vW
        self.vH = vH
    }
    
}

