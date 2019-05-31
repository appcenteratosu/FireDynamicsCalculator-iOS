////
//  BaseViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 5/30/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var topView: UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "ombre header"))
        return imgView
    }()

}
