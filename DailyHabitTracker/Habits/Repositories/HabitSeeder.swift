//
//  HabitSeeder.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation

struct HabitSeeder {
    private let repository: HabitRepository

    init(repository: HabitRepository) {
        self.repository = repository
    }

    func seedDefaultHabitsIfNeeded() throws {
        guard try repository.loadHabits().isEmpty else { return }

        for habit in [
            Habit(name: "Walk"),
            Habit(name: "Meditation"),
            Habit(name: "Gym")
        ] {
            try repository.addHabit(habit)
        }
    }
}
