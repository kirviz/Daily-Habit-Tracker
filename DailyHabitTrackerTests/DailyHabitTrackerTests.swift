//
//  DailyHabitTrackerTests.swift
//  DailyHabitTrackerTests
//
//  Created by Darius on 16/06/2026.
//

import Foundation
import Testing
@testable import DailyHabitTracker

struct DailyHabitTrackerTests {
    private let fixedToday = Date(timeIntervalSince1970: 1_781_827_200)

    @Test func initializesWithDefaultHabits() {
        let viewModel = HabitListViewModel()

        #expect(viewModel.habits.map(\.name) == ["Walk", "Meditation", "Gym"])
        #expect(viewModel.completions.isEmpty)
        #expect(viewModel.isShowingAddHabit == false)
    }

    @Test func addHabitAppendsTrimmedName() {
        let viewModel = HabitListViewModel(habits: [])

        viewModel.addHabit(named: "  Read  ")

        #expect(viewModel.habits.map(\.name) == ["Read"])
    }

    @Test func addHabitIgnoresEmptyName() {
        let viewModel = HabitListViewModel(habits: [])

        viewModel.addHabit(named: "   \n")

        #expect(viewModel.habits.isEmpty)
    }
    
    @Test func addsHabitMultipleTimes() {
        let viewModel = HabitListViewModel(habits: [])

        viewModel.addHabit(named: "One")
        viewModel.addHabit(named: "Two")
        viewModel.addHabit(named: "Three")

        #expect(viewModel.habits.map(\.name) == ["One", "Two", "Three"])
    }

    @Test func toggleTodayCompletionMarksHabitCompletedToday() {
        let habit = Habit(name: "Read")
        let viewModel = HabitListViewModel(habits: [habit], today: { fixedToday })

        viewModel.toggleTodayCompletion(for: habit)

        #expect(viewModel.isCompletedToday(habit))
        #expect(viewModel.completions.map(\.habitID) == [habit.id])
    }
    
    @Test func toggleTodayCompletionTwiceReturnsToIncompleteToday() {
        let habit = Habit(name: "Read")
        let viewModel = HabitListViewModel(habits: [habit], today: { fixedToday })

        viewModel.toggleTodayCompletion(for: habit)
        viewModel.toggleTodayCompletion(for: habit)

        #expect(viewModel.isCompletedToday(habit) == false)
        #expect(viewModel.completions.isEmpty)
    }

    @Test func toggleTodayCompletionPreservesPreviousDayCompletion() {
        let habit = Habit(name: "Read")
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let yesterday = fixedToday.addingTimeInterval(-86_400)
        let viewModel = HabitListViewModel(
            habits: [habit],
            completions: [HabitCompletion(habitID: habit.id, date: yesterday)],
            calendar: calendar,
            today: { fixedToday }
        )

        viewModel.toggleTodayCompletion(for: habit)

        #expect(viewModel.isCompletedToday(habit))
        #expect(viewModel.completions == [
            HabitCompletion(habitID: habit.id, date: yesterday),
            HabitCompletion(habitID: habit.id, date: fixedToday)
        ])
    }

}
