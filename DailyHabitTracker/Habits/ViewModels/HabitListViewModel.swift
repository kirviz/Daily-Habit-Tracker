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
    var persistenceError: Error?

    private let repository: HabitRepository
    private let calendar: Calendar
    private let today: () -> Date

    init(
        repository: HabitRepository = InMemoryHabitRepository(),
        calendar: Calendar = .current,
        today: @escaping () -> Date = Date.init
    ) {
        self.repository = repository
        do {
            self.habits = try repository.loadHabits()
            self.completions = try repository.loadCompletions()
        } catch {
            self.habits = []
            self.completions = []
            self.persistenceError = error
        }
        self.calendar = calendar
        self.today = today
    }

    convenience init(
        habits: [Habit],
        completions: [HabitCompletion] = [],
        calendar: Calendar = .current,
        today: @escaping () -> Date = Date.init
    ) {
        self.init(
            repository: InMemoryHabitRepository(habits: habits, completions: completions),
            calendar: calendar,
            today: today
        )
    }

    func addHabit(named name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        habits.append(Habit(name: trimmedName))
        do {
            try repository.saveHabits(habits)
            persistenceError = nil
        } catch {
            habits.removeLast()
            persistenceError = error
        }
    }

    func deleteHabits(at offsets: IndexSet) {
        let previousHabits = habits
        let previousCompletions = completions
        let deletedHabitIDs = Set(offsets.compactMap { index in
            habits.indices.contains(index) ? habits[index].id : nil
        })

        habits.removeAll { deletedHabitIDs.contains($0.id) }
        completions.removeAll { deletedHabitIDs.contains($0.habitID) }
        do {
            try repository.saveHabits(habits)
            try repository.saveCompletions(completions)
            persistenceError = nil
        } catch {
            habits = previousHabits
            completions = previousCompletions
            persistenceError = error
        }
    }

    func isCompletedToday(_ habit: Habit) -> Bool {
        isCompleted(habit, on: today())
    }

    func isCompleted(_ habit: Habit, on date: Date) -> Bool {
        completions.contains { completion in
            completion.habitID == habit.id && calendar.isDate(completion.date, inSameDayAs: date)
        }
    }

    func recentDates(count: Int) -> [Date] {
        guard count > 0 else { return [] }

        let today = calendar.startOfDay(for: today())
        return (0..<count).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)
        }
    }

    func toggleTodayCompletion(for habit: Habit) {
        toggleCompletion(for: habit, on: today())
    }

    func toggleCompletion(for habit: Habit, on date: Date) {
        guard habits.contains(where: { $0.id == habit.id }) else { return }

        let previousCompletions = completions
        if let completionIndex = completions.firstIndex(where: { completion in
            completion.habitID == habit.id && calendar.isDate(completion.date, inSameDayAs: date)
        }) {
            completions.remove(at: completionIndex)
        } else {
            completions.append(HabitCompletion(habitID: habit.id, date: date))
        }

        do {
            try repository.saveCompletions(completions)
            persistenceError = nil
        } catch {
            completions = previousCompletions
            persistenceError = error
        }
    }
}
