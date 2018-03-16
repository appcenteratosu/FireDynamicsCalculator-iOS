//
//  OxygenLevelsGraphViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/15/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit
import Charts


class OxygenLevelsGraphViewController: UIViewController, ChartViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        chart.delegate = self
        updateChartData(set: data!)
        chart.notifyDataSetChanged()
        
        if graphType == 1 {
            self.title = "Heat Release vs. Time"
        } else if graphType == 2 {
            self.title = "O2 Consumption vs. Time"
        } else {
            self.title = "% O2 vs. Time"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var chart: LineChartView!
    var data: (times: [Double], vals: [Double])?
    var graphType: Int?
    
    func updateChartData(set: (times: [Double], vals: [Double])) {
        var entry: [ChartDataEntry] = []
        
        for i in 1..<set.times.count {
            let point = ChartDataEntry(x: set.times[i], y: set.vals[i])
            entry.append(point)
        }
        
        var line = LineChartDataSet()
        
        if graphType == 1 {
            line = LineChartDataSet(values: entry, label: "Heat release over time")
        } else if graphType == 2 {
            line = LineChartDataSet(values: entry, label: "Total Energy Consumed over time")
        } else {
            line = LineChartDataSet(values: entry, label: "% of remaining O2 in room over time")
        }
        
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
        
        if graphType == 1 {
            desc.text = "\(entry.x.rounded(toPlaces: 0)) sec, \(entry.y.rounded(toPlaces: 2)) kW"
        } else if graphType == 2 {
            desc.text = "\(entry.x.rounded(toPlaces: 0)) sec, \(entry.y.rounded(toPlaces: 2)) kg"
        } else {
            desc.text = "\(entry.x.rounded(toPlaces: 0)) sec, \(entry.y.rounded(toPlaces: 2))%"
        }
        
        chartView.chartDescription = desc
        let font = UIFont(name: UIFont.fontNames(forFamilyName: "Avenir Next")[0], size: 15)
        chartView.chartDescription?.font = font!
        
    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
    }

}
