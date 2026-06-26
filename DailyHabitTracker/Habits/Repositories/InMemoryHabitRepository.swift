//
//  InMemoryHabitRepository.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation

nonisolated final class InMemoryHabitRepository: HabitRepository {
    private var habits: [Habit]
    private var completions: [HabitCompletion]

    init(
        habits: [Habit] = [],
        completions: [HabitCompletion] = []
    ) {
        self.habits = habits
        self.completions = completions
    }

    func loadHabits() throws -> [Habit] {
        habits
    }

    func saveHabits(_ habits: [Habit]) throws {
        self.habits = habits
    }

    func loadCompletions() throws -> [HabitCompletion] {
        completions
    }

    func saveCompletions(_ completions: [HabitCompletion]) throws {
        self.completions = completions
    }
}
