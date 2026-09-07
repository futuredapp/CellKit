import XCTest

final class ExampleUITests: XCTestCase {
    private var app: XCUIApplication!
    private var table: XCUIElement!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5))
    }

    func testLaunchShowsSections() {
        XCTAssertTrue(table.staticTexts["Welcome!"].exists)
        XCTAssertTrue(table.staticTexts["iPhone tapped: 0"].exists)
        XCTAssertGreaterThan(table.cells.count, 1)
    }

    func testTapUpdatesCellThroughDiff() {
        let cell = table.staticTexts["iPhone tapped: 0"]
        XCTAssertTrue(cell.exists)
        cell.tap()

        XCTAssertTrue(table.staticTexts["iPhone tapped: 1"].waitForExistence(timeout: 5))
        XCTAssertFalse(table.staticTexts["iPhone tapped: 0"].exists)
    }

    func testInsertAndResetThroughDiff() {
        // The name label of whatever device cell is currently first in the "Cell Phones" section.
        let firstDeviceName = table.cells.element(boundBy: 1).staticTexts
            .matching(NSPredicate(format: "label CONTAINS 'tapped:'"))
            .firstMatch
        XCTAssertEqual(firstDeviceName.label, "iPhone tapped: 0")

        app.navigationBars.buttons["+iPhone"].tap()
        wait(until: firstDeviceName, "label != %@", "iPhone tapped: 0")
        XCTAssertTrue(firstDeviceName.label.hasPrefix("iPhone"))
        XCTAssertTrue(firstDeviceName.label.hasSuffix(" tapped: 0"))
        XCTAssertTrue(table.staticTexts["iPhone tapped: 0"].exists)

        app.navigationBars.buttons["+Android"].tap()
        wait(until: firstDeviceName, "NOT label BEGINSWITH 'iPhone'")
        XCTAssertTrue(firstDeviceName.label.hasSuffix(" tapped: 0"))

        app.navigationBars.buttons["Reset"].tap()
        wait(until: firstDeviceName, "label == %@", "iPhone tapped: 0")
    }

    private func wait(until element: XCUIElement, _ format: String, _ arguments: CVarArg..., timeout: TimeInterval = 5) {
        let predicate = NSPredicate(format: format, argumentArray: arguments)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: timeout), .completed, "Timed out waiting for: \(format)")
    }
}
