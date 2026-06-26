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

        let habit = Habit(name: trimmedName)
        do {
            try repository.addHabit(habit)
            habits.append(habit)
            persistenceError = nil
        } catch {
            handlePersistenceFailure(error)
        }
    }

    func deleteHabits(at offsets: IndexSet) {
        let deletedHabitIDs = Set(offsets.compactMap { index in
            habits.indices.contains(index) ? habits[index].id : nil
        })

        do {
            for habitID in deletedHabitIDs {
                try repository.deleteHabit(id: habitID)
            }
            habits.removeAll { deletedHabitIDs.contains($0.id) }
            completions.removeAll { deletedHabitIDs.contains($0.habitID) }
            persistenceError = nil
        } catch {
            handlePersistenceFailure(error)
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

        if let completionIndex = completions.firstIndex(where: { completion in
            completion.habitID == habit.id && calendar.isDate(completion.date, inSameDayAs: date)
        }) {
            do {
                try repository.deleteCompletion(habitID: habit.id, on: date, calendar: calendar)
                completions.remove(at: completionIndex)
                persistenceError = nil
            } catch {
                handlePersistenceFailure(error)
            }
        } else {
            let completion = HabitCompletion(habitID: habit.id, date: date)
            do {
                try repository.addCompletion(completion)
                completions.append(completion)
                persistenceError = nil
            } catch {
                handlePersistenceFailure(error)
            }
        }
    }

    private func handlePersistenceFailure(_ error: Error) {
        do {
            habits = try repository.loadHabits()
            completions = try repository.loadCompletions()
        } catch {
            // Keep the current in-memory state if recovery loading also fails.
        }

        persistenceError = error
    }
}
