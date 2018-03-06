//
//  t2_FiresViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 2/26/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit
import Charts

class t2_FiresViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupToolbar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var t1: UITextField!
    @IBOutlet weak var peakHRR: UITextField!
    @IBOutlet weak var time: UITextField!
    
    @IBOutlet var toolbar: UIToolbar!
    func setupToolbar() {
        self.t1.inputAccessoryView = toolbar
        self.peakHRR.inputAccessoryView = toolbar
        self.time.inputAccessoryView = toolbar
    }
    
    func closeEditor() {
        self.view.endEditing(true)
    }
    
    @IBAction func doneEditing(_ sender: Any) {
        closeEditor()
    }
    
    @IBAction func calculate(_ sender: Any) {
        
        guard let t1 = Double(t1.text!) else { return }
        guard let peak = Double(peakHRR.text!) else { return }
        guard let time = Int(time.text!) else { return }
        let alpha = 1000 / pow(t1, 2.0)
        
        
        let calc = t2_calculator(t1: t1, alpha: alpha, peak: peak, time: time)
        
        let set = (calc.timeSet, calc.heatSet)
        
        performSegue(withIdentifier: "showChart", sender: set)
        
    }
    
    struct t2_calculator {
        
        private var t1: Double
        private var alpha: Double
        private var peak: Double
        private var time: Int
        
        init(t1: Double, alpha: Double, peak: Double, time: Int) {
            self.t1 = t1
            self.alpha = alpha
            self.peak = peak
            self.time = time
            
            let data = createDataSet()
            self.timeSet = data.times
            self.heatSet = data.heats
            
        }
        
        var timeSet: [Int] = []
        var heatSet: [Double] = []
        
        
        private func createDataSet() -> (times: [Int], heats: [Double]) {
            var timeSet = [0]
            var heatSet = [0.0]
            
            var totalSeconds = 0
            while totalSeconds < 1000 {
                let last = timeSet.last!
                let newSecondEntry = last + time
                timeSet.append(newSecondEntry)
                
                if (alpha * pow(Double(newSecondEntry), 2)) > peak {
                    let newHeat = peak
                    heatSet.append(newHeat)
                } else {
                    let newheat = alpha * pow(Double(newSecondEntry), 2)
                    heatSet.append(newheat)
                }
                
                
                totalSeconds += time
            }
            
            let index = heatSet.index { (value) -> Bool in
                return value == peak
            }
            
            let endIndex = index! + 4
            let finalHeat = Array(heatSet[0...endIndex])
            let finalTime = Array(timeSet[0...endIndex])
            
            
            return (finalTime, heatSet)
        }
        
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChart" {
            if let vc = segue.destination as? t2GraphViewController {
                if let data = sender as? ([Int], [Double]) {
                    vc.times = data.0
                    vc.heats = data.1
                }
            }
        }
    }
 

}
