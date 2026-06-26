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
        habits: [Habit] = [],
        completions: [HabitCompletion] = []
    ) {
        self.habits = habits
        self.completions = completions
    }

    func loadHabits() throws -> [Habit] {
        habits
    }

    func addHabit(_ habit: Habit) throws {
        habits.append(habit)
    }

    func deleteHabit(id: Habit.ID) throws {
        habits.removeAll { $0.id == id }
        completions.removeAll { $0.habitID == id }
    }

    func loadCompletions() throws -> [HabitCompletion] {
        completions
    }

    func addCompletion(_ completion: HabitCompletion) throws {
        completions.append(completion)
    }

    func deleteCompletion(habitID: Habit.ID, on date: Date, calendar: Calendar) throws {
        completions.removeAll { completion in
            completion.habitID == habitID && calendar.isDate(completion.date, inSameDayAs: date)
        }
    }
}
