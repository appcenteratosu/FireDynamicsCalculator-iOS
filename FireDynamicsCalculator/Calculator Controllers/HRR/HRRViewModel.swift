////
//  HRRViewModel.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 6/1/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation

typealias FuelChoiceSet = (effectiveHeat: Double, heatFlux: Double)
class HRRViewModel {
    
    // MARK: - Q Conversions
    static let btu = 1.055055852
    static let kw = 1.0
    
    // MARK: - PickerData
    var methodChoices = ["Please Select an Option",
                         "Area",
                         "Radius"]
    
    var fuelChoices = ["Please Select an Option",
                       "Cellulose",
                       "Gasoline",
                       "Heptane",
                       "Methanol",
                       "PMMA",
                       "Polyethylene",
                       "Polypropylene",
                       "Polystyrene",
                       "PVC",
                       "Wood"]
    
    var areaChoices = ["Please Select an Option",
                       "m²",
                       "ft²",
                       "inch²"]
    
    var energyChoices = ["Please Select an Option",
                         "kW",
                         "Btu / sec"]
    
    var lengthChoices = ["Please Select an Option",
                         "cm",
                         "feet",
                         "inches",
                         "meters",
                         "mm"]
    
    var fuelData: [String: FuelChoiceSet] = ["Cellulose": (16.1, 14),
                                         "Gasoline": (43.7, 55),
                                         "Heptane": (44.6, 70),
                                         "Methanol": (19.8, 22),
                                         "PMMA": (24.9, 28),
                                         "Polyethylene": (43.3, 26),
                                         "Polypropylene": (43.3, 24),
                                         "Polystyrene": (39.8, 38),
                                         "PVC": (16.4, 16),
                                         "Wood": (14, 11)]
    
}

