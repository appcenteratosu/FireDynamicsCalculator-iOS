//
//  t2GraphViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 2/26/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit
import Charts

class t2GraphViewController: UIViewController, ChartViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        chart.delegate = self
        updateChartData(times: self.times!, heats: self.heats!)
        chart.notifyDataSetChanged()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var chart: LineChartView!
    
    func updateChartData(times: [Int], heats: [Double]) {
        var entry: [ChartDataEntry] = []
        
        for i in 0..<times.count {
            let point = ChartDataEntry(x: Double(times[i]), y: heats[i])
            entry.append(point)
        }
        
        let line = LineChartDataSet(values: entry, label: "Heat increase over time")
        line.colors = [UIColor.black]
        line.circleColors = [UIColor.black]
        line.circleRadius = 5
        line.drawCircleHoleEnabled = false
        
        let data = LineChartData()
        data.addDataSet(line)
        
        chart.data = data
        chart.highlightPerTapEnabled = true
        
        chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    var times: [Int]?
    var heats: [Double]?
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let desc = Description()
        desc.text = "\(entry.x.rounded(toPlaces: 2)), \(entry.y.rounded(toPlaces: 2))"
        
        chartView.chartDescription = desc
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
