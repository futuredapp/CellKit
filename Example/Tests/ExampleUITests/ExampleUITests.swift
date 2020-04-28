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
