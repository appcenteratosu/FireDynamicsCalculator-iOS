////
//  HRRCalculator.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 6/1/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation

class HRRCalculator {
    
    func calculate(area: Double, mFlux: Double, heatCombustion: Double, areaUnits: UnitArea, qConversion: Double) -> Double {
        let areaMeasurement = Measurement(value: area, unit: areaUnits)
        let areaInMeters = areaMeasurement.converted(to: .squareMeters)
        
        let hrr = (mFlux * heatCombustion * areaInMeters.value) * qConversion
        
        return hrr
    }
    
    func calculate(area: Double, mFlux: Double, heatCombustion: Double, areaUnits: UnitArea, qUnit: UnitPower) -> Double {
        let areaMeasurement = Measurement(value: area, unit: areaUnits)
        let areaInMeters = areaMeasurement.converted(to: .squareMeters)
        
        var base = Measurement(value: (mFlux * heatCombustion * areaInMeters.value), unit: UnitPower.kilowatts)
        
        
        if qUnit == UnitPower.btuPerSecond {
            let hrr = base * 1.055055852
            return hrr.value
        } else {
            return base.value
        }
    }
    
    func calculate(fuel: FuelChoiceSet, area: Double, areaUnits: UnitArea, qUnit: UnitPower) -> Double {
        let areaMeasurement = Measurement(value: area, unit: areaUnits)
        let areaInMeters = areaMeasurement.converted(to: .squareMeters)
        
        var base = Measurement(value: (fuel.heatFlux * fuel.effectiveHeat * areaInMeters.value),
                               unit: UnitPower.kilowatts)
        
        
        if qUnit == UnitPower.btuPerSecond {
            let hrr = base * 1.055055852
            return hrr.value
        } else {
            return base.value
        }
    }
    
    func calculate(fuel: FuelChoiceSet, radius: Double, lengthUnits: UnitLength, qUnit: UnitPower) -> Double {
        let lengthMeasurement = Measurement(value: radius, unit: lengthUnits)
        let area = Double.pi * pow(lengthMeasurement.value, 2)
        
        var areaMeasurement: Measurement<UnitArea>
        switch lengthUnits {
        case UnitLength.inches:
            areaMeasurement = Measurement(value: area, unit: UnitArea.squareInches)
        case UnitLength.millimeters:
            areaMeasurement = Measurement(value: area, unit: UnitArea.squareMillimeters)
        case UnitLength.meters:
            areaMeasurement = Measurement(value: area, unit: UnitArea.squareMeters)
        case UnitLength.feet:
            areaMeasurement = Measurement(value: area, unit: UnitArea.squareFeet)
        case UnitLength.centimeters:
            areaMeasurement = Measurement(value: area, unit: UnitArea.squareCentimeters)
        default:
            fatalError()
        }
        
        let areaInMeters = areaMeasurement.converted(to: .squareMeters)
        
        var base = Measurement(value: (fuel.heatFlux * fuel.effectiveHeat * areaInMeters.value),
                               unit: UnitPower.kilowatts)
        
        
        if qUnit == UnitPower.btuPerSecond {
            let hrr = base * 1.055055852
            return hrr.value
        } else {
            return base.value
        }
    }
    
    
}

extension UnitPower {
    static var btuPerSecond: UnitPower {
        let unitConverter = UnitConverterLinear(coefficient: 1.055055852 * 1000, constant: 0)
        let unit = UnitPower(symbol: "Btu", converter: unitConverter)
        
        return unit
    }
}

