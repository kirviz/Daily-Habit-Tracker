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
    var isCompleted = false
}
