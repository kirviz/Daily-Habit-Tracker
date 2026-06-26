//
//  HabitRepository.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation

protocol HabitRepository {
    func loadHabits() throws -> [Habit]
    func addHabit(_ habit: Habit) throws
    func deleteHabit(id: Habit.ID) throws
    func loadCompletions() throws -> [HabitCompletion]
    func addCompletion(_ completion: HabitCompletion) throws
    func deleteCompletion(habitID: Habit.ID, on date: Date, calendar: Calendar) throws
}
