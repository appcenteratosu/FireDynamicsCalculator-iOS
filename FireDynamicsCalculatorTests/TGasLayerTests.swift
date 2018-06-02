//
//  TGasLayerTests.swift
//  FireDynamicsCalculatorTests
//
//  Created by App Center on 6/2/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import XCTest
@testable import FireDynamicsCalculator

class TGasLayerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTGasLayer() {
        let calc = TGasLayCalculator()
        let vc = TGasLayerViewController()
        var T = calc.calculate(cW: "8", cWUnits: vc.length[2],
                               cL: "12", cLUnits: vc.length[2],
                               cH: "7", cHUnits: vc.length[2],
                               vW: "12", vWUnits: vc.length[2],
                               vH: "6", vHUnits: vc.length[2],
                               thickness: "0.5", thicknessUnits: vc.length[3],
                               lining: vc.materials[13],
                               Q: "50", Q_Units: vc.energy[1],
                               tamb: "72", tambUnits: vc.temperature[2],
                               TUnits: vc.temperature[1])!
        let round = T.rounded(toPlaces: 1)
        
        if abs(round - 624.8) < 1 {
            XCTAssertTrue(true)
        } else {
            XCTAssertTrue(false)
        }
        
    }
    
}
