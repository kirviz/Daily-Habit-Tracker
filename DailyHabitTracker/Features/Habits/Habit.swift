//
//  Habit.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation

struct Habit: Identifiable {
    let id = UUID()
    let name: String
}

nonisolated struct HabitCompletion: Equatable {
    let habitID: Habit.ID
    let date: Date
}
