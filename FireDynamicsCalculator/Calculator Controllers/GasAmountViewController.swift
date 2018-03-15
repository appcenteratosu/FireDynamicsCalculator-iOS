//
//  GasAmountViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/13/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class GasAmountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}

struct GasAmountCalculator {
    
    enum Gases {
        case Methane
        case Propane
        case UserSpecified
    }
    
    enum GasProps {
        case LEL
        case Stoich
        case UEL
        case VaporDensity
        case LiquidDensity
    }
    
    let gasData: [Gases : [GasProps: Double]] = [.Methane: [.LEL: 0.05, .Stoich: 0.0952, .UEL: 0.15, .VaporDensity: 0.6407, .LiquidDensity: 0.0],
                                                 .Propane: [.LEL: 0.021, .Stoich: 0.0626, .UEL: 0.095, .VaporDensity: 1.554, .LiquidDensity: 580],
                                                 .UserSpecified: [.LEL: 0.02, .Stoich: 0.045, .UEL: 0.09, .VaporDensity: 1.8, .LiquidDensity: 540]]
    
    struct Results {
        var gasVolume: [GasProps: Double]
        var gasWeight: [GasProps: Double]
        var liquidVolume: [GasProps: Double?]
    }
    
    func calculate(typeOfGas: String, area: String, areaUnits: String, height: String, heightUnits: String, volGasUnit: String, weightGasUnit: String, volLiqUnit: String) -> Results {
        var gasType: Gases
        
        switch typeOfGas {
        case "Propane":
            gasType = .Propane
        case "Methane":
            gasType = .Methane
        case "User Specified":
            gasType = .UserSpecified
        default:
            gasType = .Propane
        }
        
        let area = Conversion.Area().area(value: Double(area)!, from: Conversion.Area().getAreaUnits(from: areaUnits))
        let height = Conversion.Length().convertLength(value: Double(height)!, from: Conversion.Length().getLengthUnits(from: heightUnits))
        let vAboveBelow = area * height
        
        let gasInfo = gasData[gasType]!
        
        let LEL = gasInfo[.LEL]!
        let Stoich = gasInfo[.Stoich]!
        let UEL = gasInfo[.UEL]!
        
        let vaporDensity = gasInfo[.VaporDensity]!
        let liqDensity = gasInfo[.LiquidDensity]!
        let liqDensityConv = Conversion.Volume().convertVolume(value: liqDensity, from: Conversion.Volume().getUnits(string: volLiqUnit))
        
        // gas vol
        let a1 = Conversion.Volume().convertToCubM(value: (LEL * vAboveBelow), from: Conversion.Volume().getUnits(string: volGasUnit))
        let b1 = Conversion.Volume().convertToCubM(value: (Stoich * vAboveBelow), from: Conversion.Volume().getUnits(string: volGasUnit))
        let c1 = Conversion.Volume().convertToCubM(value: (UEL * vAboveBelow), from: Conversion.Volume().getUnits(string: volGasUnit))
        
        // gas weight
        let a2 = Conversion.Mass().convertToKg(value: (a1 * vaporDensity), from: Conversion.Mass().getUnits(string: weightGasUnit))
        let b2 = Conversion.Mass().convertToKg(value: (b1 * vaporDensity), from: Conversion.Mass().getUnits(string: weightGasUnit))
        let c2 = Conversion.Mass().convertToKg(value: (c1 * vaporDensity), from: Conversion.Mass().getUnits(string: weightGasUnit))
        
        // liq vol
        var a3: Double?
        var b3: Double?
        var c3: Double?
        
        if liqDensity != 0.0 {
            a3 = Conversion.Mass().convertMass(value: a2, from: Conversion.Mass().getUnits(string: weightGasUnit)) / liqDensityConv
            b3 = Conversion.Mass().convertMass(value: b2, from: Conversion.Mass().getUnits(string: weightGasUnit)) / liqDensityConv
            c3 = Conversion.Mass().convertMass(value: c2, from: Conversion.Mass().getUnits(string: weightGasUnit)) / liqDensityConv
        } else {
            a3 = nil
            
        }
        
        
        let results = Results(gasVolume: [.LEL: a1, .Stoich: b1, .UEL: c1],
                              gasWeight: [.LEL: a2, .Stoich: b2, .UEL: c2],
                              liquidVolume: [.LEL: a3, .Stoich: b3, .UEL: c3])
        
        return results
        
    }
    
    
}
