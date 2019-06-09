////
//  FlameHeightViewModel.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 6/8/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation

class FlameHeightViewModel {
    
    // MARK: - Calculator
    let calculator = FlameHeightCalculator()
    
    // MARK: - Picker DataSource
    let length: [String] = ["Please Select an option", "m", "cm", "ft", "mm", "in"]
    let heat: [String] = ["Please Select an option", "kW", "Btu / Sec"]
    let area: [String] = ["Please Select an option", "m²", "ft²", "in²"]
}
