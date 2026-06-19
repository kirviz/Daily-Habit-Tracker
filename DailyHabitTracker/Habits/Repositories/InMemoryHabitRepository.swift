//
//  InMemoryHabitRepository.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation

final class InMemoryHabitRepository: HabitRepository {
    private var habits: [Habit]
    private var completions: [HabitCompletion]

    init(
        habits: [Habit] = InMemoryHabitRepository.defaultHabits,
        completions: [HabitCompletion] = []
    ) {
        self.habits = habits
        self.completions = completions
    }

    func loadHabits() -> [Habit] {
        habits
    }

    func saveHabits(_ habits: [Habit]) {
        self.habits = habits
    }

    func loadCompletions() -> [HabitCompletion] {
        completions
    }

    func saveCompletions(_ completions: [HabitCompletion]) {
        self.completions = completions
    }

    private static let defaultHabits = [
        Habit(name: "Walk"),
        Habit(name: "Meditation"),
        Habit(name: "Gym")
    ]
}
