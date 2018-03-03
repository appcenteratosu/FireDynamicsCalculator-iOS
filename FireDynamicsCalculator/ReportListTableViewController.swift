//
//  ReportListTableViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 1/21/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class ReportListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    let headers = ["Flashover",
                   "Heat Release Rate",
                   "Flame Height",
                   "t2 Fires",
                   "Radiation Pool",
                   "Conduction",
                   "Solid Ignition"]
    let descriptions = ["Fire size required for flashover", "Fire Size", "Predict flame height", "Predict size of exponentially growing fire", "Predict radiant flux from a pool fire", "Predict conductive heat flux through a material", "Predict ignition time"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return headers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = headers[indexPath.row]
        cell.detailTextLabel?.text = descriptions[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch headers[indexPath.row] {
        case "Flashover":
           performSegue(withIdentifier: "flashover", sender: self)
        case "Heat Release Rate":
            performSegue(withIdentifier: "HRR", sender: self)
        case "Flame Height":
            performSegue(withIdentifier: "flameHeight", sender: self)
        case "t2 Fires":
            performSegue(withIdentifier: "t2Fire", sender: self)
        case "Radiation Pool":
            performSegue(withIdentifier: "radiationPool", sender: self)
        case "Conduction":
            performSegue(withIdentifier: "conduction", sender: self)
        default:
            print("Error")
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
