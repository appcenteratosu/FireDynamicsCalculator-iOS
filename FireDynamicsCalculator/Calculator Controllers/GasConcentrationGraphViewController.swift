//
//  GasConcentrationGraphViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/13/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit
import Charts

class GasConcentrationGraphViewController: UIViewController, ChartViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gas Concentration Chart"

        chart.delegate = self
        updateChartData(set: self.data)
        chart.notifyDataSetChanged()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var data: [(Double, Double)]!
    
    @IBOutlet weak var chart: LineChartView!
    
    func updateChartData(set: [(time: Double, conc: Double)]) {
        var entry: [ChartDataEntry] = []
        
        for i in 0..<set.count {
            let point = ChartDataEntry(x: set[i].time, y: set[i].conc)
            entry.append(point)
        }
        
        let line = LineChartDataSet(values: entry, label: "Gas Concentration over time")
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
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let desc = Description()
        desc.text = "\(entry.x.rounded(toPlaces: 2)) Hours, \(entry.y.rounded(toPlaces: 2))%"
        
        chartView.chartDescription = desc
        let font = UIFont(name: UIFont.fontNames(forFamilyName: "Avenir Next")[0], size: 15)
        chartView.chartDescription?.font = font!
        
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
