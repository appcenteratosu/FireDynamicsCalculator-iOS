//
//  Conversion.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 1/28/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import Foundation

class Conversion {
    func length(value: Double, from unit: Units.Length) -> Double {
        switch unit {
        case .cm:
            return value * 0.01
        case .feet:
            return value * 0.304878049
        case .inches:
            return value * 0.025406504
        case .meters:
            return value * 1.0
        case .mm:
            return value * 0.001
        }
    }
    
    func getLengthUnits(from: String) -> Units.Length {
        switch from {
        case "cm":
            return .cm
        case "ft":
            return .feet
        case "in":
            return .inches
        case "m":
            return .meters
        case "mm":
            return .mm
        default:
            return .meters
        }
    }
    
    func volume(value: Double, from unit: Units.Volume) -> Double {
        switch unit {
        case .ftCub:
            return value * 0.0283168
        case .gallon:
            return value * 0.00378541
        case .inchesCub:
            return value * 0.0000163870562770569
        case .liter:
            return value * 0.001
        case .metersCub:
            return value * 1.0
        }
    }
    
    func density(value: Double, from unit: Units.Density) -> Double {
        switch unit {
        case .kgCubM:
            return value * 1.0
        case .lbCubFt:
            return value * 0.062427818
        }
    }
    
    func energy(value: Double, from unit: Units.Energy) -> Double {
        switch unit {
        case .BtuSec:
            return value * 1.055055852
        case .kW:
            return value * 1.0
        }
    }
    
    func getEnergyUnits(from: String) -> Units.Energy {
        switch from {
        case "Btu / Sec":
            return .BtuSec
        case "kW":
            return .kW
        default:
            return .kW
        }
    }
    
    func area(value: Double, from unit: Units.Area) -> Double {
        switch unit {
        case .FtSq:
            return value * 0.092950625
        case .inchesSq:
            return value * 0.00064549
        case .mSq:
            return value * 1.0
        }
    }
    
    func getAreaUnits(from: String) -> Units.Area {
        switch from {
        case "ft²":
            return .FtSq
        case "in²":
            return .inchesSq
        case "m²":
            return .mSq
        default:
            return .mSq
        }
    }
    
    func mass(value: Double, from unit: Units.Mass) -> Double {
        switch unit {
        case .g:
            return value * 0.001
        case .kg:
            return value * 1.0
        case .lb:
            return value * 0.453592
        }
    }
    
    func energyDensity(value: Double, to unit: Units.EnergyDensity) -> Double {
        switch unit {
        case .Btu_Sec_ft²:
            return value * 1/11.3565267
        case .kW_m²:
            return value * 1.0
        }
    }
    
    func getEnergyDensityUnits(from: String) -> Units.EnergyDensity {
        switch from {
        case "Btu/sec/ft²":
            return .Btu_Sec_ft²
        case "kW/m²":
            return .kW_m²
        default:
            return .kW_m²
        }
    }
    
    func time(value: Double, from unit: Units.Time) -> Double {
        switch unit {
        case .Hour:
            return value * (1/3600)
        case .Min:
            return value * (1/60)
        case .Sec:
            return value * 1
        }
    }
    
    func getTimeUnits(string: String) -> Units.Time {
        switch string {
        case "Hr":
            return .Hour
        case "Min":
            return .Min
        case "Sec":
            return .Sec
        default:
            return .Sec
        }
    }
    
    func pressure(value: Double, from unit: Units.Pressure) -> Double {
        switch unit {
        case .inchesH2O:
            return value * 2.490889083
        case .kPa:
            return value * 10
        case .mbar:
            return value * 1
        case .psi:
            return value * 68.9475728
        }
    }
    
    func flow(value: Double, from unit: Units.Flow) -> Double {
        switch unit {
        case .cfm:
            return value * 0.588125867
        case .cubFtSec:
            return value * 0.009802098
        case .cubMHr:
            return value * 1
        case .cubMSec:
            return value * 0.000277778
        }
    }
    
    func getTemperatureUnits(string: String) -> Units.Temperature {
        switch string {
        case "C":
            return .C
        case "F":
            return .F
        case "K":
            return .K
        case "R":
            return .R
        default:
            return .C
        }
    }
    
    func convertTemperature(value: String, from units: Units.Temperature) -> Double {
        if let value = Double(value) {
            if units == .F {
                let result = (value - 32) * ( 5  / 9)
                return result
            } else if units == .C {
                return value
            } else if units == .K {
                let result = value - 273.15
                return result
            } else {
                let result = (value - 459.67 - 32 ) * (5 / 9)
                return result
            }
        } else {
            return 0.0
        }
    }
    

    struct Units {
        enum Length {
            case cm
            case feet
            case inches
            case meters
            case mm
        }
        
        func length(value: String) -> Length {
            switch value {
            case "cm":
                return .cm
            case "feet":
                return .feet
            case "inches":
                return .inches
            case "meters":
                return .meters
            case "mm":
                return .mm
            default:
                return .feet
            }
        }
        
        enum Volume {
            case ftCub
            case gallon
            case inchesCub
            case liter
            case metersCub
        }
        
        enum Density {
            case kgCubM
            case lbCubFt
        }
        
        enum Energy {
            case kW
            case BtuSec
        }
        
        enum Area {
            case FtSq
            case inchesSq
            case mSq
        }
        
        enum Mass {
            case g
            case kg
            case lb
        }
        
        enum Time {
            case Hour
            case Min
            case Sec
        }
        
        enum Pressure {
            case inchesH2O
            case kPa
            case mbar
            case psi
        }
        
        enum EnergyDensity {
            case Btu_Sec_ft²
            case kW_m²
        }
        
        enum Flow {
            case cfm
            case cubFtSec
            case cubMHr
            case cubMSec
        }
        
        enum Temperature {
            case C
            case F
            case K
            case R
        }
        
    }
    
    struct Materials {
        func getMaterialValue(material: material) -> Double {
            switch material {
            case .AeratedConcrete:
                return 0.00026
            case .AluminaSilicateBlock:
                return 0.00014
            case .Aluminum:
                return 0.206
            case .Brick:
                return 0.0008
            case .BrickConcreteBlock:
                return 0.00073
            case .CalciumSilicateBoard:
                return 0.00013
            case .Chipboard:
                return 0.00015
            case .Concrete:
                return 0.0016
            case .ExpendedPolystyrene:
                return 0.000034
                
            case .FiberInsulationBoard:
                return 0.00053
            case .GlassFiberInsulation:
                return 0.000037
            case .GlassPlate:
                return 0.00076
                
            case .GypsumBoard:
                return 0.00017
            case .Plasterboard:
                return 0.00016
            case .Plywood:
                return 0.00012
                
            case .Steel:
                return 0.054
            }
        }
    
    
        enum material {
            case AeratedConcrete
            case AluminaSilicateBlock
            case Aluminum
            case Brick
            case BrickConcreteBlock
            case CalciumSilicateBoard
            case Chipboard
            case Concrete
            case ExpendedPolystyrene
            
            case FiberInsulationBoard
            case GlassFiberInsulation
            case GlassPlate
            
            case GypsumBoard
            case Plasterboard
            case Plywood
            
            case Steel
        }
        
        
    
    }
    
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
        
    }
}












