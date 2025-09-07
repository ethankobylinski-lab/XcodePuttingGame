import XCTest

final class SessionRestorationUITests: XCTestCase {
    @MainActor
    func testSessionPersistsAcrossLaunches() {
        let app = XCUIApplication()
        app.launch()

        let startButton = app.buttons["startButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()

        let countdownLabel = app.staticTexts["countdownLabel"]
        XCTAssertTrue(countdownLabel.waitForExistence(timeout: 2))
        sleep(1)
        let valueBeforeKill = countdownLabel.label

        app.terminate()
        sleep(1)
        app.launch()

        let resumedLabel = app.staticTexts["countdownLabel"]
        XCTAssertTrue(resumedLabel.waitForExistence(timeout: 2))
        XCTAssertNotEqual(resumedLabel.label, valueBeforeKill)
    }
}
