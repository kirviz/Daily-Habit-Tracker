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

        if try fetchHabits().isEmpty {
            saveHabits(Self.defaultHabits)
        }
    }

    func loadHabits() -> [Habit] {
        do {
            return try fetchHabits()
        } catch {
            print("Failed to load habits: \(error)")
            return []
        }
    }

    func saveHabits(_ habits: [Habit]) {
        replaceAll(SwiftDataHabit.self) {
            habits.enumerated().map { index, habit in
                SwiftDataHabit(
                    id: habit.id,
                    name: habit.name,
                    createdAt: Date(timeIntervalSinceReferenceDate: TimeInterval(index))
                )
            }
        }
    }

    func loadCompletions() -> [HabitCompletion] {
        let descriptor = FetchDescriptor<SwiftDataHabitCompletion>(
            sortBy: [
                SortDescriptor(\.date),
                SortDescriptor(\.habitID)
            ]
        )

        do {
            return try context.fetch(descriptor).map(\.habitCompletion)
        } catch {
            print("Failed to load habit completions: \(error)")
            return []
        }
    }

    func saveCompletions(_ completions: [HabitCompletion]) {
        replaceAll(SwiftDataHabitCompletion.self) {
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
    ) {
        do {
            try context.fetch(FetchDescriptor<Model>()).forEach(context.delete)
            models().forEach(context.insert)
            try context.save()
        } catch {
            print("Failed to save \(modelType): \(error)")
        }
    }

    private func fetchHabits() throws -> [Habit] {
        let descriptor = FetchDescriptor<SwiftDataHabit>(
            sortBy: [SortDescriptor(\.createdAt)]
        )

        return try context.fetch(descriptor).map(\.habit)
    }

    private static let defaultHabits = [
        Habit(name: "Walk"),
        Habit(name: "Meditation"),
        Habit(name: "Gym")
    ]
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
