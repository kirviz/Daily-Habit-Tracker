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
    var completions: [HabitCompletion]
    var isShowingAddHabit = false

    private let calendar: Calendar
    private let today: () -> Date

    init(
        habits: [Habit] = HabitListViewModel.defaultHabits,
        completions: [HabitCompletion] = [],
        calendar: Calendar = .current,
        today: @escaping () -> Date = Date.init
    ) {
        self.habits = habits
        self.completions = completions
        self.calendar = calendar
        self.today = today
    }

    func addHabit(named name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        habits.append(Habit(name: trimmedName))
    }

    func isCompletedToday(_ habit: Habit) -> Bool {
        isCompleted(habit, on: today())
    }

    func toggleTodayCompletion(for habit: Habit) {
        guard habits.contains(where: { $0.id == habit.id }) else { return }

        let completionDate = today()
        if let completionIndex = completions.firstIndex(where: { completion in
            completion.habitID == habit.id && calendar.isDate(completion.date, inSameDayAs: completionDate)
        }) {
            completions.remove(at: completionIndex)
        } else {
            completions.append(HabitCompletion(habitID: habit.id, date: completionDate))
        }
    }

    private func isCompleted(_ habit: Habit, on date: Date) -> Bool {
        completions.contains { completion in
            completion.habitID == habit.id && calendar.isDate(completion.date, inSameDayAs: date)
        }
    }

    private static let defaultHabits = [
        Habit(name: "Walk"),
        Habit(name: "Meditation"),
        Habit(name: "Gym")
    ]
}
