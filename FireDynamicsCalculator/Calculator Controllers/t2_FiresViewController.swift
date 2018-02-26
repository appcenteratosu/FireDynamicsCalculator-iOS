//
//  t2_FiresViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 2/26/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class t2_FiresViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var t1: UITextField!
    @IBOutlet weak var peakHRR: UITextField!
    @IBOutlet weak var time: UITextField!
    
    
    
    
    @IBAction func calculate(_ sender: Any) {
        
        guard let t1 = Double(t1.text!) else { return }
        guard let peak = Double(peakHRR.text!) else { return }
        guard let time = Int(time.text!) else { return }
        let alpha = 1000 / pow(t1, 2.0)
        
        
        let calc = t2_calculator(t1: t1, alpha: alpha, peak: peak, time: time)
        
        let set = (calc.timeSet, calc.heatSet)
        
        
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
            
            
            return (timeSet, heatSet)
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
