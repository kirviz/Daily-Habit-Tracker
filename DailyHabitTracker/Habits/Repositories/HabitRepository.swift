//
//  HabitRepository.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation

protocol HabitRepository {
    func loadHabits() -> [Habit]
    func saveHabits(_ habits: [Habit])
    func loadCompletions() -> [HabitCompletion]
    func saveCompletions(_ completions: [HabitCompletion])
}
