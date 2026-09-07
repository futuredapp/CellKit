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
    }

    func testLaunchShowsSections() {
        XCTAssertTrue(table.waitForExistence(timeout: 5))
        XCTAssertTrue(table.staticTexts["Welcome!"].exists)
        XCTAssertTrue(table.staticTexts["iPhone tapped: 0"].exists)
        XCTAssertGreaterThan(table.cells.count, 1)
    }

    func testTapUpdatesCellThroughDiff() {
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        let cell = table.staticTexts["iPhone tapped: 0"]
        XCTAssertTrue(cell.exists)
        cell.tap()

        XCTAssertTrue(table.staticTexts["iPhone tapped: 1"].waitForExistence(timeout: 5))
        XCTAssertFalse(table.staticTexts["iPhone tapped: 0"].exists)
    }

    func testInsertAndResetThroughDiff() {
        XCTAssertTrue(table.waitForExistence(timeout: 5))
        let firstDeviceCell = table.cells.element(boundBy: 1)
        let nameLabel = firstDeviceCell.staticTexts.matching(NSPredicate(format: "label CONTAINS 'tapped:'")).firstMatch
        XCTAssertEqual(nameLabel.label, "iPhone tapped: 0")

        app.navigationBars.buttons["+iPhone"].tap()

        let inserted = nameLabel
        XCTAssertTrue(inserted.waitForExistence(timeout: 5))
        XCTAssertNotEqual(inserted.label, "iPhone tapped: 0")
        XCTAssertTrue(inserted.label.hasSuffix(" tapped: 0"))
        XCTAssertTrue(table.staticTexts["iPhone tapped: 0"].exists)

        app.navigationBars.buttons["+Android"].tap()
        let insertedAndroid = nameLabel
        XCTAssertTrue(insertedAndroid.waitForExistence(timeout: 5))
        XCTAssertFalse(insertedAndroid.label.hasPrefix("iPhone"))

        app.navigationBars.buttons["Reset"].tap()

        let reset = NSPredicate(format: "label == %@", "iPhone tapped: 0")
        let expectation = XCTNSPredicateExpectation(predicate: reset, object: nameLabel)
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 5), .completed)
    }
}
