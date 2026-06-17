//
//  DailyHabitTrackerUITests.swift
//  DailyHabitTrackerUITests
//
//  Created by Darius on 16/06/2026.
//

import XCTest

final class DailyHabitTrackerUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testAddHabitAndMarkComplete() throws {
        app.buttons["Add"].tap()

        let habitNameField = app.textFields["Habit name"]
        XCTAssertTrue(habitNameField.waitForExistence(timeout: 2))
        habitNameField.tap()
        habitNameField.typeText("Read")

        app.buttons["Save"].tap()

        let readHabit = app.buttons["Mark Read complete"]
        XCTAssertTrue(readHabit.waitForExistence(timeout: 2))
        readHabit.tap()
    }

    @MainActor
    func testNavigateToFirstHabitDetails() throws {
        openDetails(for: "Walk")

        XCTAssertTrue(app.navigationBars["Walk"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Last 7 Days"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["habit-history-row-0"].waitForExistence(timeout: 2))
    }

    @MainActor
    func testTogglePastHabitCompletionFromDetails() throws {
        openDetails(for: "Walk")

        let yesterdayRow = app.buttons["habit-history-row-1"]
        XCTAssertTrue(yesterdayRow.waitForExistence(timeout: 2))
        XCTAssertTrue(yesterdayRow.label.hasPrefix("Mark complete"))

        yesterdayRow.tap()
        XCTAssertTrue(yesterdayRow.waitForLabelPrefix("Mark incomplete", timeout: 2))

        yesterdayRow.tap()
        XCTAssertTrue(yesterdayRow.waitForLabelPrefix("Mark complete", timeout: 2))
    }
    
    @MainActor
    func testCompletingInDetailsPersistsInHabitsList() throws {
        openDetails(for: "Walk")

        let todayRow = app.buttons["habit-history-row-0"]
        XCTAssertTrue(todayRow.waitForExistence(timeout: 2))
        XCTAssertTrue(todayRow.label.hasPrefix("Mark complete"))
        
        todayRow.tap()
        XCTAssertTrue(todayRow.waitForLabelPrefix("Mark incomplete", timeout: 2))
        app/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".navigationBars",".buttons",".buttons[\"Daily Habits\"]",".buttons[\"BackButton\"]"],[[[-1,3],[-1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

        let walkHabit = app.buttons["Mark Walk incomplete"]
        XCTAssertTrue(walkHabit.waitForExistence(timeout: 2))
    }

    @MainActor
    private func openDetails(for habitName: String) {
        let detailsButton = app.buttons["habit-details-\(habitName)"]
        XCTAssertTrue(detailsButton.waitForExistence(timeout: 2))
        detailsButton.tap()
    }
}

private extension XCUIElement {
    func waitForLabelPrefix(_ prefix: String, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "label BEGINSWITH %@", prefix)

        return XCTNSPredicateExpectation(predicate: predicate, object: self)
            .waitForExpectation(timeout: timeout)
    }
}

private extension XCTNSPredicateExpectation {
    func waitForExpectation(timeout: TimeInterval) -> Bool {
        XCTWaiter.wait(for: [self], timeout: timeout) == .completed
    }
}
