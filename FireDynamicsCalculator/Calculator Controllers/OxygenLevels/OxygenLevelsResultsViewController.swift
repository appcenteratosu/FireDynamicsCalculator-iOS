//
//  OxygenLevelsResultsViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/15/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class OxygenLevelsResultsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.dataSource = self
        picker.delegate = self
        picker.isHidden = true
        
        units.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        
        if let result = results {
            self.timeTo14Percent.text = "\(result.TT14)"
            self.seconds = result.TT14
        }
        
    }
    
    @IBOutlet weak var units: UIButton!
    @IBAction func changeUnits(_ sender: Any) {
        picker.isHidden = false
        picker.selectRow(0, inComponent: 0, animated: false)
    }
    
    var seconds: Double?
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData = Conversion.UnitString().time
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
        
        units.setTitle(selected, for: .normal)
        
        let converted = Conversion.Time().time(value: seconds!,
                                               from: Conversion.Time().getTimeUnits(string: selected))
        
        self.timeTo14Percent.text = "\(converted.rounded(toPlaces: 2))"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != picker {
                picker.isHidden = true
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var results: (TT14: Double, DataSet: [[String: Double]])?
    
    @IBOutlet weak var timeTo14Percent: UILabel!
    
    @IBAction func showGraphHRR(_ sender: Any) {
        let data = prepareData(graph: .HRR)
        performSegue(withIdentifier: "showGraph", sender: (data, 1))
    }
    
    @IBAction func showGraphConcumption(_ sender: Any) {
        let data = prepareData(graph: .Consumption)
        performSegue(withIdentifier: "showGraph", sender: (data, 2))
    }
    
    @IBAction func showGraphO2(_ sender: Any) {
        let data = prepareData(graph: .O2)
        performSegue(withIdentifier: "showGraph", sender: (data, 3))
    }
    
    func prepareData(graph: graphs) -> (x: [Double], y: [Double]) {
        
        var x: [Double] = []
        var y: [Double] = []
        
        if let data = results?.DataSet {
            switch graph {
            case .HRR:
                for item in data {
                    if let nx = item["time"] {
                        x.append(nx)
                    }
                    if let ny = item["HRR"] {
                        y.append(ny)
                    }
                }
            case .Consumption:
                for item in data {
                    if let nx = item["time"] {
                        x.append(nx)
                    }
                    if let ny = item["O2Cons"] {
                        y.append(ny)
                    }
                }
            case .O2:
                for item in data {
                    if let nx = item["time"] {
                        x.append(nx)
                    }
                    if let ny = item["%O2"] {
                        y.append(ny)
                    }
                }
            }
        }
        
        return (x, y)
    
        
    }
    
    enum graphs {
        case HRR
        case Consumption
        case O2
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showGraph" {
            if let vc = segue.destination as? OxygenLevelsGraphViewController {
                if let data = sender as? (data: ([Double], [Double]), type: Int) {
                    vc.data = data.data
                    vc.graphType = data.type
                }
            }
        }
        
    }

}
