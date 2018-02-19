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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    let list = ["Flashover", "Heat Release Rate", "Self Heating", "Radiation", "Conduction", "Radiation"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = list[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch list[indexPath.row] {
        case "Flashover":
           performSegue(withIdentifier: "flashover", sender: self)
        case "Heat Release Rate":
            performSegue(withIdentifier: "HRR", sender: self)
        case "Self Heating":
            performSegue(withIdentifier: "flashover", sender: self)
        case "Radiation":
            performSegue(withIdentifier: "flashover", sender: self)
        case "Conduction":
            performSegue(withIdentifier: "flashover", sender: self)
        case "Radiation":
            performSegue(withIdentifier: "flashover", sender: self)
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
