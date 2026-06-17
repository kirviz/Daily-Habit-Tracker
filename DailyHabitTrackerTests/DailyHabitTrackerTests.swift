//
//  DailyHabitTrackerTests.swift
//  DailyHabitTrackerTests
//
//  Created by Darius on 16/06/2026.
//

import Testing
@testable import DailyHabitTracker

struct DailyHabitTrackerTests {

    @Test func initializesWithDefaultHabits() {
        let viewModel = HabitListViewModel()

        #expect(viewModel.habits.map(\.name) == ["Walk", "Meditation", "Gym"])
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

    @Test func toggleCompletionUpdatesMatchingHabit() {
        let habit = Habit(name: "Read")
        let viewModel = HabitListViewModel(habits: [habit])

        viewModel.toggleCompletion(for: habit)

        #expect(viewModel.habits[0].isCompleted == true)
    }

}
