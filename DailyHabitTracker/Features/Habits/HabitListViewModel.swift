//
//  HabitListViewModel.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation
import Observation

@Observable
final class HabitListViewModel {
    var habits: [Habit]
    var isShowingAddHabit = false

    init(habits: [Habit] = HabitListViewModel.defaultHabits) {
        self.habits = habits
    }

    func addHabit(named name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        habits.append(Habit(name: trimmedName))
    }

    func toggleCompletion(for habit: Habit) {
        guard let habitIndex = habits.firstIndex(where: { $0.id == habit.id }) else { return }

        habits[habitIndex].isCompleted.toggle()
    }

    private static let defaultHabits = [
        Habit(name: "Walk"),
        Habit(name: "Meditation"),
        Habit(name: "Gym")
    ]
}
