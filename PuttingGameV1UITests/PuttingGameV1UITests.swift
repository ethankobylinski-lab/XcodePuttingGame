//
//  PuttingGameV1UITests.swift
//  PuttingGameV1UITests
//
//  Created by Ethan Kobylinski on 7/6/25.
//

import XCTest
import QuartzCore

final class PuttingGameV1UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    @MainActor
    func testMinimumFrameRate() throws {
        let app = XCUIApplication()
        app.launch()

        let expectation = XCTestExpectation(description: "Measure 1s of frames")
        var measuredFPS: Double = 0

        let counter = FrameCounter(duration: 1) { fps in
            measuredFPS = fps
            expectation.fulfill()
        }
        counter.start()

        wait(for: [expectation], timeout: 2)
        XCTAssertGreaterThanOrEqual(measuredFPS, 55, "Expected at least 55 fps on iPhone 12")
    }
}

/// Utility object that counts display link frames over a fixed duration.
private final class FrameCounter {
    private let duration: CFTimeInterval
    private let completion: (Double) -> Void
    private var displayLink: CADisplayLink?
    private var start: CFTimeInterval = 0
    private var frames: Int = 0

    init(duration: CFTimeInterval, completion: @escaping (Double) -> Void) {
        self.duration = duration
        self.completion = completion
    }

    func start() {
        start = CFAbsoluteTimeGetCurrent()
        displayLink = CADisplayLink(target: self, selector: #selector(step(link:)))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc private func step(link: CADisplayLink) {
        frames += 1
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        if elapsed >= duration {
            link.invalidate()
            completion(Double(frames) / elapsed)
        }
    }
}
