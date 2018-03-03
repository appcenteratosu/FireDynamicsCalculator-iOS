//
//  ConductionViewController.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 3/2/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import UIKit

class ConductionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    struct ConductionCalculator {
        init(material: String, thickness: String, thicknessUnits: String, t2: String, t2Units: String, t1: String, t1Units: String) {
            self.material = Helper().getMaterial(string: material)
            self.thickness = Helper().getThicknessInMeters(string: thickness, units: thicknessUnits)
            self.t1 = Conversion().convertTemperature(value: t1, from: Conversion().getTemperatureUnits(string: t1Units))
            self.t2 = Conversion().convertTemperature(value: t2, from: Conversion().getTemperatureUnits(string: t2Units))
        }
        
        let material: ConductionMaterial
        let thickness: Double
        let t1: Double
        let t2: Double
        
        func calculate(qUnits: Conversion.EnergyDensity, tUnits: Conversion.Time) -> (q: Double, t: Double) {
            
            let k = material.thermalConductivity / 1000
            let tempDiff = t2 - t1
            let l = thickness
            
            let sub = (k * tempDiff / l)
            let q = Conversion().energyDensity(value: sub, to: qUnits)
            
            let sub2 = (pow(l, 2.0) / (16 * material.thermalDiffusivity))
            let t = Conversion().time(value: sub2, from: tUnits)
            
            return (q.rounded(toPlaces: 4), t.rounded(toPlaces: 2))
        }
        
        
        // MARK: - Helper and Setup
        struct Helper {
            func getMaterial(string: String) -> ConductionMaterial {
                switch string {
                case "Air":
                    let CM = ConductionMaterials()
                    return CM.Air
                case "Asbestos":
                    let CM = ConductionMaterials()
                    return CM.Asbestos
                case "Brick":
                    let CM = ConductionMaterials()
                    return CM.Brick
                case "Concrete High":
                    let CM = ConductionMaterials()
                    return CM.ConcreteHigh
                case "Concrete Low":
                    let CM = ConductionMaterials()
                    return CM.ConcreteLow
                case "Copper":
                    let CM = ConductionMaterials()
                    return CM.Copper
                case "Fiber Insulating Board":
                    let CM = ConductionMaterials()
                    return CM.FiberInsulatingBoard
                case "Glass Plate":
                    let CM = ConductionMaterials()
                    return CM.GlassPlate
                case "Gypsum Plaster":
                    let CM = ConductionMaterials()
                    return CM.GypsumPlaster
                case "Oak":
                    let CM = ConductionMaterials()
                    return CM.Oak
                case "PMMA":
                    let CM = ConductionMaterials()
                    return CM.PMMA
                case "Polyurethane Foam":
                    let CM = ConductionMaterials()
                    return CM.PolyurethaneFoam
                case "Steel Mild":
                    let CM = ConductionMaterials()
                    return CM.SteelMild
                case "Yellow Pine":
                    let CM = ConductionMaterials()
                    return CM.YellowPine
                default:
                    let CM = ConductionMaterials()
                    return CM.Air
                }
            }
            func getThicknessInMeters(string: String, units: String) -> Double {
                let thickness = Double(string)!
                let thicknessUnits = Conversion().getLengthUnits(from: units)
                
                let result = Conversion().convertLength(value: thickness, from: thicknessUnits)
                return result
            }
        }
        struct ConductionMaterials {
            let Air = ConductionMaterial(thermalConductivity: 0.026, specificHeat: 1.04, density: 1.1, thermalDiffusivity: 2.27273E-05, thermalInertia: 3.00E-05)
            let Asbestos = ConductionMaterial(thermalConductivity: 0.15, specificHeat: 1.05, density: 577, thermalDiffusivity: 2.47586E-07, thermalInertia: 0.091)
            let Brick = ConductionMaterial(thermalConductivity: 0.69, specificHeat: 0.84, density: 1600, thermalDiffusivity: 5.13393E-07, thermalInertia: 0.93)
            let ConcreteHigh = ConductionMaterial(thermalConductivity: 1.4, specificHeat: 0.88, density: 2300, thermalDiffusivity: 6.917E-07, thermalInertia: 2)
            let ConcreteLow = ConductionMaterial(thermalConductivity: 0.8, specificHeat: 0.88, density: 1900, thermalDiffusivity: 4.78469E-07, thermalInertia: 2)
            let Copper = ConductionMaterial(thermalConductivity: 387, specificHeat: 0.38, density: 8940, thermalDiffusivity: 0.000113917, thermalInertia: 1300)
            let FiberInsulatingBoard = ConductionMaterial(thermalConductivity: 0.041, specificHeat: 2.09, density: 229, thermalDiffusivity: 8.56647E-08, thermalInertia: 0.02)
            let GlassPlate = ConductionMaterial(thermalConductivity: 0.76, specificHeat: 0.84, density: 2700, thermalDiffusivity: 3.35097E-07, thermalInertia: 1.7)
            let GypsumPlaster = ConductionMaterial(thermalConductivity: 0.48, specificHeat: 0.84, density: 1440, thermalDiffusivity: 3.96825E-07, thermalInertia: 0.58)
            let Oak = ConductionMaterial(thermalConductivity: 0.17, specificHeat: 2.38, density: 800, thermalDiffusivity: 8.92857E-08, thermalInertia: 0.32)
            let PMMA = ConductionMaterial(thermalConductivity: 0.19, specificHeat: 1.42, density: 1190, thermalDiffusivity: 1.12439E-07, thermalInertia: 0.32)
            let PolyurethaneFoam = ConductionMaterial(thermalConductivity: 0.034, specificHeat: 1.4, density: 20, thermalDiffusivity: 1.21429E-06, thermalInertia: 9.50E-04)
            let SteelMild = ConductionMaterial(thermalConductivity: 45.8, specificHeat: 0.46, density: 7850, thermalDiffusivity: 1.26835E-05, thermalInertia: 160)
            let YellowPine = ConductionMaterial(thermalConductivity: 0.14, specificHeat: 2.85, density: 640, thermalDiffusivity: 7.67544E-08, thermalInertia: 0.25)
        }
        struct ConductionMaterial {
            let thermalConductivity: Double
            let specificHeat: Double
            let density: Double
            let thermalDiffusivity: Double
            let thermalInertia: Double
        }
        
        
    }


}
