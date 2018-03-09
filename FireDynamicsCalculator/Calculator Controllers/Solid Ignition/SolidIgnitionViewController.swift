//
//  SolidIgnitionViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/5/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit
import SnapKit

class SolidIgnitionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, PickerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPicker()
        
    }

    // MARK: Method Selection
    let options = ["Please Select an Option", "Thermally Thin", "Thermally Thick", "Thermally Thick with Materials"]
    @IBOutlet weak var methodSelectionButton: UIButton!
    @IBAction func selectMethod(_ sender: Any) {
        pickerData = options
        openPicker()
    }
    
    var currentUIView: UIView?
    func checkForAndHandleOpenViews() {
        if let view = currentUIView {
            view.removeFromSuperview()
        }
    }
    
    @IBOutlet var thermallyThinUIView: ThermallyThinView!
    @IBOutlet var thermallyThickUIVIew: ThermallyThickView!
    @IBOutlet var thermallyThinkWithMaterialsUIView: ThermallyThickMaterialsView!
    
    var responderDelegate: PickerResponderDelegate?
    
    func open(view: UIView) {
//        checkForAndHandleOpenViews()
        
        if view == thermallyThinUIView {
            thermallyThinUIView.pickerDelegate = self
            self.responderDelegate = thermallyThinUIView
            thermallyThinUIView.configure()
            
            self.view.addSubview(thermallyThinUIView)
            
            thermallyThinUIView.snp.makeConstraints({ (make) in
                make.top.equalTo(methodSelectionButton).offset(25)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(380)
            })
        } else if view == thermallyThickUIVIew {
            thermallyThickUIVIew.pickerDelegate = self
            self.responderDelegate = thermallyThickUIVIew
            thermallyThickUIVIew.configure()
            
            self.view.addSubview(thermallyThickUIVIew)
            
            thermallyThickUIVIew.snp.makeConstraints({ (make) in
                make.top.equalTo(methodSelectionButton).offset(25)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(400)
            })
            
        } else if view == thermallyThinkWithMaterialsUIView {
            thermallyThinkWithMaterialsUIView.pickerDelegate = self
            self.responderDelegate = thermallyThinkWithMaterialsUIView
            thermallyThinkWithMaterialsUIView.configure()
            
            self.view.addSubview(thermallyThinkWithMaterialsUIView)
            
            thermallyThinkWithMaterialsUIView.snp.makeConstraints({ (make) in
                make.top.equalTo(methodSelectionButton).offset(25)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(275)
            })
        }
    }
    
    // Data
    let density: [String] = ["Please Select an Option", "kg/m³", "lb/ft³"]
    let length: [String] = ["Please Select an Option", "m", "cm", "ft", "mm", "in"]
    let temperature: [String] = ["Please Select an Option", "°C","°F","K","R"]
    let energy: [String] = ["Please Select an Option", "Btu/sec/ft²", "kW/m²"]
    let materials: [String] = ["Please Select an Option", "Air", "Asbestos", "Brick", "Concrete High", "Concrete Low", "Copper", "Fiber Insulating Board", "Glass Plate", "Gypsum Plaster", "Oak", "PMMA", "Polyurethane Foam", "Steel Mild", "Yellow Pine"]
    let time: [String] = ["Please Select an Option", "Hr", "Min", "Sec"]
    
    // MARK: Picker
    var pickerData: [String] = []
    
    @IBOutlet weak var picker: UIPickerView!
    func setupPicker() {
        picker.delegate = self
        picker.dataSource = self
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
        let selection = pickerData[row]
        
        if pickerData != options {
            if userIsSelectingMaterial {
                responderDelegate?.didSelectOption(option: selection)
            } else {
                responderDelegate?.didSelectOption(option: selection)
                closePicker()
            }
        } else {
            self.methodSelectionButton.setTitle(selection, for: .normal)
            
            checkForAndHandleOpenViews()
            if selection == options[1] {
                currentUIView = thermallyThinUIView
                open(view: thermallyThinUIView)
                closePicker()
            } else if selection == options[2] {
                currentUIView = thermallyThickUIVIew
                open(view: thermallyThickUIVIew)
                closePicker()
            } else if selection == options[3] {
                currentUIView = thermallyThinkWithMaterialsUIView
                open(view: thermallyThinkWithMaterialsUIView)
                closePicker()
            }
        }
        
    }

    var userIsSelectingMaterial: Bool = false
    func setDataSource(dataSet: Conversion.Units.List) {
        switch dataSet {
        case .Density:
            self.pickerData = self.density
        case .Length:
            self.pickerData = self.length
        case .Temperature:
            self.pickerData = self.temperature
        case .Materials:
            self.pickerData = SolidIgnitionCalculator().materials.getKeyList()
            userIsSelectingMaterial = true
        case .Time:
            self.pickerData = self.time
        case .EneregyDensity:
            self.pickerData = self.energy
        default:
            print("Error Setting data")
        }
        
        openPicker()
    }
    
    func openPicker() {
        picker.reloadAllComponents()
        picker.selectRow(0, inComponent: 0, animated: false)
        picker.isHidden = false
    }
    
    func closePicker() {
        picker.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if userIsSelectingMaterial {
            if let touch = touches.first {
                if touch.view != picker {
                    closePicker()
                    userIsSelectingMaterial = false
                }
            }
        }
    }

}

protocol PickerResponderDelegate {
    func didSelectOption(option: String)
}

