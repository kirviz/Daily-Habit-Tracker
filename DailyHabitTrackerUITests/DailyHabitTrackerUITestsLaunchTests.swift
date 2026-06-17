//
//  DailyHabitTrackerUITestsLaunchTests.swift
//  DailyHabitTrackerUITests
//
//  Created by Darius on 16/06/2026.
//

import XCTest

final class DailyHabitTrackerUITestsLaunchTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
