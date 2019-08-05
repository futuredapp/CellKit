//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Matěj Kašpar Jirásek on 17/07/2019.
//  Copyright © 2019 FUNTASTY Digital, s.r.o. All rights reserved.
//

import XCTest

final class ExampleUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        XCUIApplication().launch()
    }

    func testLaunch() {
        XCTAssert(true)
    }
}
