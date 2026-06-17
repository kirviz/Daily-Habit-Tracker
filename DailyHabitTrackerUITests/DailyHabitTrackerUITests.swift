//
//  DailyHabitTrackerUITests.swift
//  DailyHabitTrackerUITests
//
//  Created by Darius on 16/06/2026.
//

import XCTest

final class DailyHabitTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testAddHabitAndMarkComplete() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Add"].tap()

        let habitNameField = app.textFields["Habit name"]
        XCTAssertTrue(habitNameField.waitForExistence(timeout: 2))
        habitNameField.tap()
        habitNameField.typeText("Read")

        app.buttons["Save"].tap()

        let readHabit = app.buttons["Read"]
        XCTAssertTrue(readHabit.waitForExistence(timeout: 2))
        readHabit.tap()
    }
}
