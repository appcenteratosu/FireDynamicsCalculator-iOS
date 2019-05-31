//
//  VariousTest.swift
//  FireDynamicsCalculatorTests
//
//  Created by App Center on 6/2/18.
//  Copyright © 2018 Luke Davis Development. All rights reserved.
//

import XCTest
import UIKit
@testable import FireDynamicsCalculator

class VariousTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasics() {
        let time: TimeInterval = 1527973662
        let cl = Tests()
        let times = cl.toTimeStamp(time: time)
        print(times)
        
    }
    
}
