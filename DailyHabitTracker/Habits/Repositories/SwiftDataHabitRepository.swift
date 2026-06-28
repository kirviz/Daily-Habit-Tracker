//
//  SwiftDataHabitRepository.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation
import SwiftData

final class SwiftDataHabitRepository: HabitRepository {
    private let container: ModelContainer
    private let context: ModelContext

    convenience init() throws {
        let container = try ModelContainer(
            for: SwiftDataHabit.self,
            SwiftDataHabitCompletion.self
        )
        self.init(container: container)
    }

    init(container: ModelContainer) {
        self.container = container
        self.context = container.mainContext
    }

    static func makeInMemoryContainer() throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

        return try ModelContainer(
            for: SwiftDataHabit.self,
            SwiftDataHabitCompletion.self,
            configurations: configuration
        )
    }

    func loadHabits() throws -> [Habit] {
        try fetchHabits()
    }

    func addHabit(_ habit: Habit) throws {
        context.insert(SwiftDataHabit(id: habit.id, name: habit.name, createdAt: Date()))
        try context.save()
    }

    func deleteHabit(id: Habit.ID) throws {
        for habit in try fetchSwiftDataHabits(id: id) {
            context.delete(habit)
        }

        for completion in try fetchSwiftDataCompletions(habitID: id) {
            context.delete(completion)
        }

        try context.save()
    }

    func loadCompletions() throws -> [HabitCompletion] {
        let descriptor = FetchDescriptor<SwiftDataHabitCompletion>(
            sortBy: [
                SortDescriptor(\.date),
                SortDescriptor(\.habitID)
            ]
        )

        return try context.fetch(descriptor).map(\.habitCompletion)
    }

    func addCompletion(_ completion: HabitCompletion) throws {
        context.insert(SwiftDataHabitCompletion(habitID: completion.habitID, date: completion.date))
        try context.save()
    }

    func deleteCompletion(habitID: Habit.ID, on date: Date, calendar: Calendar) throws {
        for completion in try fetchSwiftDataCompletions(habitID: habitID) where calendar.isDate(completion.date, inSameDayAs: date) {
            context.delete(completion)
        }

        try context.save()
    }

    private func fetchHabits() throws -> [Habit] {
        let descriptor = FetchDescriptor<SwiftDataHabit>(
            sortBy: [SortDescriptor(\.createdAt)]
        )

        return try context.fetch(descriptor).map(\.habit)
    }

    private func fetchSwiftDataHabits(id: Habit.ID) throws -> [SwiftDataHabit] {
        let descriptor = FetchDescriptor<SwiftDataHabit>(
            predicate: #Predicate { habit in
                habit.id == id
            }
        )

        return try context.fetch(descriptor)
    }

    private func fetchSwiftDataCompletions(habitID: Habit.ID) throws -> [SwiftDataHabitCompletion] {
        let descriptor = FetchDescriptor<SwiftDataHabitCompletion>(
            predicate: #Predicate { completion in
                completion.habitID == habitID
            }
        )

        return try context.fetch(descriptor)
    }
}

@Model
final class SwiftDataHabit {
    var id: UUID
    var name: String
    var createdAt: Date

    init(id: UUID, name: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }

    var habit: Habit {
        Habit(id: id, name: name)
    }
}

@Model
final class SwiftDataHabitCompletion {
    var habitID: UUID
    var date: Date

    init(habitID: UUID, date: Date) {
        self.habitID = habitID
        self.date = date
    }

    var habitCompletion: HabitCompletion {
        HabitCompletion(habitID: habitID, date: date)
    }
}
