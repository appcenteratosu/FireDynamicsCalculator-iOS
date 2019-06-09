////
//  FlameHeightTests.swift
//  FireDynamicsCalculator
//
//  Created by App Center on 6/9/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import XCTest
@testable import FireDynamicsCalculator

class FlameHeightTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCalculateFromDiameter() {
        // setup
        let calculator = FlameHeightCalculator()
        
        let q = 375.0
        let qUnit = UnitPower.kilowatts
        
        let d = 3.0
        let dUnit = UnitLength.feet
        
        let lUnit = UnitLength.feet
        
        let L = 5.02
        
        // Assert
        let result = calculator.calculate(Q: q, qUnits: qUnit, D: d, dUnits: dUnit, lUnit: lUnit)
        
        XCTAssertEqual(result.value, L, accuracy: 0.1)
        
    }
    
    func testCalculateRadius() {
        // setup
        let calculator = FlameHeightCalculator()
        
        let q = 375.0
        let qUnit = UnitPower.kilowatts
        
        let a = 15.0
        let aUnit = UnitArea.squareFeet
        
        let lUnit = UnitLength.feet
        
        let L = 3.62
        
        // Assert
        let result = calculator.calculate(Q: q, qUnits: qUnit,
                                          A: a, aUnits: aUnit,
                                          lUnit: lUnit)
        
        XCTAssertEqual(result.value, L, accuracy: 0.1)
    }

}
