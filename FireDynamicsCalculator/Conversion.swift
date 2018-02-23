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
    
    func volume(value: Double, to unit: Units.Volume) -> Double {
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
    
    func density(value: Double, to unit: Units.Density) -> Double {
        switch unit {
        case .kgCubM:
            return value * 1.0
        case .lbCubFt:
            return value * 0.062427818
        }
    }
    
    func energy(value: Double, to unit: Units.Energy) -> Double {
        switch unit {
        case .BtuSec:
            return value * 1.055055852
        case .kW:
            return value * 1.0
        }
    }
    
    func area(value: Double, to unit: Units.Area) -> Double {
        switch unit {
        case .FtSq:
            return value * 0.092950625
        case .inchesSq:
            return value * 0.00064549
        case .mSq:
            return value * 1.0
        }
    }
    
    func mass(value: Double, to unit: Units.Mass) -> Double {
        switch unit {
        case .g:
            return value * 0.001
        case .kg:
            return value * 1.0
        case .lb:
            return value * 0.453592
        }
    }
    
    func energyDensity(value: Double, to unit: Units.Mass) -> Double {
        switch unit {
        case .g:
            return value * 0.001
        case .kg:
            return value * 1.0
        case .lb:
            return value * 0.453592
        }
    }
    
    func time(value: Double, to unit: Units.Time) -> Double {
        switch unit {
        case .Hour:
            return value * 0.000277778
        case .Min:
            return value * 0.016666667
        case .Sec:
            return value * 1
        }
    }
    
    func pressure(value: Double, to unit: Units.Pressure) -> Double {
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
    
    func flow(value: Double, to unit: Units.Flow) -> Double {
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
    

    struct Units {
        enum Length {
            case cm
            case feet
            case inches
            case meters
            case mm
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
            case BtuSecSqFt
            case kWSqM
        }
        
        enum Flow {
            case cfm
            case cubFtSec
            case cubMHr
            case cubMSec
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












