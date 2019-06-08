////
//  Materials.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 6/1/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation


typealias MaterialSet = (name: String, value: Double)
class Materials {
    static let AeratedConcrete: MaterialSet = ("Aerated Concrete", 0.00026)
    static let AluminaSilicateBlock: MaterialSet = ("Alumina Silicate Block", 0.00014)
    static let Aluminum: MaterialSet = ("Aluminum", 0.206)
    static let Brick: MaterialSet = ("Brick", 0.0008)
    static let BrickConcreteBlock: MaterialSet = ("Brick/Concrete Block", 0.00073)
    static let CalciumSilicateBoard: MaterialSet = ("Calcium Silicate Board ", 0.00013)
    static let Chipboard: MaterialSet = ("Chipboard", 0.00015)
    static let Concrete: MaterialSet = ("Concrete", 0.0016)
    static let ExpendedPolystyrene: MaterialSet = ("Expended Polystyrene", 0.000034)
    static let FiberInsulationBoard: MaterialSet = ("Fiber Insulation Board", 0.00053)
    static let GlassFiberInsulation: MaterialSet = ("Glass Fiber Insulation", 0.000037)
    static let GlassPlate: MaterialSet = ("Glass Plate", 0.00076)
    static let GypsumBoard: MaterialSet = ("Gypsum Board", 0.00017)
    static let Plasterboard: MaterialSet = ("Plasterboard", 0.00016)
    static let Plywood: MaterialSet = ("Plywood", 0.00012)
    static let Steel: MaterialSet = ("Steel", 0.054)
}
