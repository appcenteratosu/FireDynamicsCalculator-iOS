//
//  RoundedButton.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 1/21/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        
        if self.titleLabel?.text == "Calculate" {
            self.layer.borderWidth = 0
        }
    }

}
