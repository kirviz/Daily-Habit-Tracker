//
//  SwiftDataHabitRepositoryTests.swift
//  DailyHabitTrackerTests
//
//  Created by Darius on 16/06/2026.
//

import Foundation
import Testing
@testable import DailyHabitTracker

@MainActor
struct SwiftDataHabitRepositoryTests {
    @Test func addHabitPersistsHabit() throws {
        let repository = try makeRepository()
        let habit = Habit(name: "Read")

        try repository.addHabit(habit)

        #expect(try repository.loadHabits().map(\.id) == [habit.id])
        #expect(try repository.loadHabits().map(\.name) == ["Read"])
    }

    @Test func addCompletionPersistsCompletion() throws {
        let repository = try makeRepository()
        let habit = Habit(name: "Read")
        let completionDate = Date(timeIntervalSince1970: 1_781_827_200)

        try repository.addHabit(habit)
        try repository.addCompletion(HabitCompletion(habitID: habit.id, date: completionDate))

        #expect(try repository.loadCompletions() == [
            HabitCompletion(habitID: habit.id, date: completionDate)
        ])
    }

    @Test func deleteCompletionRemovesOnlyMatchingHabitAndCalendarDay() throws {
        let repository = try makeRepository()
        let habit = Habit(name: "Read")
        let otherHabit = Habit(name: "Walk")
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let morning = Date(timeIntervalSince1970: 1_781_827_200)
        let evening = morning.addingTimeInterval(60 * 60 * 12)
        let nextDay = morning.addingTimeInterval(60 * 60 * 24)

        try repository.addHabit(habit)
        try repository.addHabit(otherHabit)
        try repository.addCompletion(HabitCompletion(habitID: habit.id, date: morning))
        try repository.addCompletion(HabitCompletion(habitID: habit.id, date: evening))
        try repository.addCompletion(HabitCompletion(habitID: habit.id, date: nextDay))
        try repository.addCompletion(HabitCompletion(habitID: otherHabit.id, date: morning))

        try repository.deleteCompletion(habitID: habit.id, on: evening, calendar: calendar)

        #expect(try repository.loadCompletions() == [
            HabitCompletion(habitID: otherHabit.id, date: morning),
            HabitCompletion(habitID: habit.id, date: nextDay)
        ])
    }

    @Test func deleteHabitRemovesHabitAndItsCompletions() throws {
        let repository = try makeRepository()
        let habit = Habit(name: "Read")
        let otherHabit = Habit(name: "Walk")
        let completionDate = Date(timeIntervalSince1970: 1_781_827_200)

        try repository.addHabit(habit)
        try repository.addHabit(otherHabit)
        try repository.addCompletion(HabitCompletion(habitID: habit.id, date: completionDate))
        try repository.addCompletion(HabitCompletion(habitID: otherHabit.id, date: completionDate))

        try repository.deleteHabit(id: habit.id)

        #expect(try repository.loadHabits().map(\.id) == [otherHabit.id])
        #expect(try repository.loadCompletions() == [
            HabitCompletion(habitID: otherHabit.id, date: completionDate)
        ])
    }

    private func makeRepository() throws -> SwiftDataHabitRepository {
        try SwiftDataHabitRepository(
            container: SwiftDataHabitRepository.makeInMemoryContainer()
        )
    }
}
