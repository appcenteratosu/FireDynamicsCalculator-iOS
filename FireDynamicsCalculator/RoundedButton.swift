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
        
    }

}
