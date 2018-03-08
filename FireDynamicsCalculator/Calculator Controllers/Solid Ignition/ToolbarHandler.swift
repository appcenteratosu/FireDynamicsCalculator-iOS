//
//  ToolbarHandler.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/8/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class ToolbarHandler: UIToolbar {

    var tbDelegate: ToolbarHandlerDelegate?
    @IBAction func endEditingButton(_ sender: Any) {
        tbDelegate?.endEditing()
    }
    
}

protocol ToolbarHandlerDelegate {
    func endEditing()
}
