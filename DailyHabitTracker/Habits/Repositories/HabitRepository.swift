//
//  HabitRepository.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation

protocol HabitRepository {
    func loadHabits() throws -> [Habit]
    func saveHabits(_ habits: [Habit]) throws
    func loadCompletions() throws -> [HabitCompletion]
    func saveCompletions(_ completions: [HabitCompletion]) throws
}
