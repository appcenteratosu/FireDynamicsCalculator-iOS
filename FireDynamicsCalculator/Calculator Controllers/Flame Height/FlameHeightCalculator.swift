////
//  FlameHeightCalculator.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 6/8/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation

public class FlameHeightCalculator {
    public func calculate(Q: Double, qUnits: UnitPower, D: Double, dUnits: UnitLength, lUnit: UnitLength) -> Measurement<UnitLength> {
        let q = Measurement(value: Q, unit: qUnits)
        let d = Measurement(value: D, unit: dUnits)
        
        let qInKW = (q.unit == UnitPower.kilowatts) ? q : Measurement(value: q.value * 1.055055852, unit: UnitPower.btuPerSecond)
        let diameterInMeters = d.converted(to: .meters)
        
        let L = (0.23 * pow(qInKW.value, 0.4) - (1.02 * diameterInMeters.value))
        
        let flameHeight = Measurement(value: L, unit: UnitLength.meters)
        
        return flameHeight.converted(to: lUnit)
    }
    
    public func calculate(Q: Double, qUnits: UnitPower, A: Double, aUnits: UnitArea, lUnit: UnitLength) -> Measurement<UnitLength> {
        
        let a = Measurement(value: A, unit: aUnits)
        let r = sqrt(a.value / Double.pi)
        var radius: Measurement<UnitLength>!
        
        if aUnits == UnitArea.squareFeet {
            radius = Measurement(value: r, unit: UnitLength.feet)
        } else if aUnits == UnitArea.squareCentimeters {
            radius = Measurement(value: r, unit: UnitLength.centimeters)
        } else if aUnits == UnitArea.squareInches {
            radius = Measurement(value: r, unit: UnitLength.inches)
        } else if aUnits == UnitArea.squareMeters {
            radius = Measurement(value: r, unit: UnitLength.meters)
        } else if aUnits == UnitArea.squareKilometers {
            radius = Measurement(value: r, unit: UnitLength.kilometers)
        }
        
        let radiusInMeters = radius.converted(to: .meters)
        let diameterInMeters = radiusInMeters * 2
        
        let result = calculate(Q: Q, qUnits: qUnits, D: diameterInMeters.value, dUnits: .meters, lUnit: lUnit)
        
        return result
    }
}
