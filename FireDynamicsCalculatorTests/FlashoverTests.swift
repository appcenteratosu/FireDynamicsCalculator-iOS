//
//  FlashoverTests.swift
//  FireDynamicsCalculatorTests
//
//  Created by App Center on 6/1/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import XCTest
@testable import FireDynamicsCalculator

class FlashoverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFlashover() {
        let vc = FlashoverViewController()
        
        let mqh = vc.MQH(a: AreaMeasures(l: MeasureSet(measure: 8.0, units: .feet),
                                         w: MeasureSet(measure: 8.0, units: .feet),
                                         h: MeasureSet(measure: 7.0, units: .feet)),
                         v: VentMeasures(vW: MeasureSet(measure: 3.0, units: .feet),
                                         vH: MeasureSet(measure: 6.0, units: .feet)),
                         t: MeasureSet(measure: 0.5, units: .inches),
                         m: .GypsumBoard)
        
        XCTAssertEqual(mqh, 591.0)
        
        let bab = vc.Babrauskas(a: AreaMeasures(l: MeasureSet(measure: 8.0, units: .feet),
                                                w: MeasureSet(measure: 8.0, units: .feet),
                                                h: MeasureSet(measure: 7.0, units: .feet)),
                                v: VentMeasures(vW: MeasureSet(measure: 3.0, units: .feet),
                                                vH: MeasureSet(measure: 6.0, units: .inches)),
                                t: MeasureSet(measure: 0.5, units: .inches),
                                m: .Aluminum)
        
        XCTAssertEqual(bab, 41.0)
        
        let thom = vc.Thomas(a: AreaMeasures(l: MeasureSet(measure: 8.0, units: .feet),
                                             w: MeasureSet(measure: 8.0, units: .feet),
                                             h: MeasureSet(measure: 7.0, units: .feet)),
                             v: VentMeasures(vW: MeasureSet(measure: 3.0, units: .feet),
                                             vH: MeasureSet(measure: 6.0, units: .inches)),
                             t: MeasureSet(measure: 0.5, units: .inches),
                             m: .GypsumBoard)
        
        XCTAssertEqual(thom, 275.0)
    }
    
}
