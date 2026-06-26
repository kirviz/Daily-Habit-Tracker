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

    init() throws {
        self.container = try ModelContainer(
            for: SwiftDataHabit.self,
            SwiftDataHabitCompletion.self
        )
        self.context = container.mainContext
    }

    func loadHabits() throws -> [Habit] {
        try fetchHabits()
    }

    func saveHabits(_ habits: [Habit]) throws {
        try replaceAll(SwiftDataHabit.self) {
            habits.enumerated().map { index, habit in
                SwiftDataHabit(
                    id: habit.id,
                    name: habit.name,
                    createdAt: Date(timeIntervalSinceReferenceDate: TimeInterval(index))
                )
            }
        }
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

    func saveCompletions(_ completions: [HabitCompletion]) throws {
        try replaceAll(SwiftDataHabitCompletion.self) {
            completions.map { completion in
                SwiftDataHabitCompletion(
                    habitID: completion.habitID,
                    date: completion.date
                )
            }
        }
    }

    private func replaceAll<Model: PersistentModel>(
        _ modelType: Model.Type,
        with models: () -> [Model]
    ) throws {
        try context.fetch(FetchDescriptor<Model>()).forEach(context.delete)
        models().forEach(context.insert)
        try context.save()
    }

    private func fetchHabits() throws -> [Habit] {
        let descriptor = FetchDescriptor<SwiftDataHabit>(
            sortBy: [SortDescriptor(\.createdAt)]
        )

        return try context.fetch(descriptor).map(\.habit)
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
