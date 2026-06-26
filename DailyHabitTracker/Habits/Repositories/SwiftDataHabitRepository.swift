//
//  SwiftDataHabitRepository.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation
import SwiftData

final class SwiftDataHabitRepository: HabitRepository {
    private let context: ModelContext

    init() throws {
        let container = try ModelContainer(
            for: SwiftDataHabit.self,
            SwiftDataHabitCompletion.self
        )
        self.context = container.mainContext

        if loadHabits().isEmpty {
            saveHabits(Self.defaultHabits)
        }
    }

    func loadHabits() -> [Habit] {
        let descriptor = FetchDescriptor<SwiftDataHabit>(
            sortBy: [SortDescriptor(\.createdAt)]
        )

        do {
            return try context.fetch(descriptor).map(\.habit)
        } catch {
            assertionFailure("Failed to load habits: \(error)")
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
            assertionFailure("Failed to load habit completions: \(error)")
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
            assertionFailure("Failed to save \(modelType): \(error)")
        }
    }

    private static let defaultHabits = [
        Habit(name: "Walk"),
        Habit(name: "Meditation"),
        Habit(name: "Gym")
    ]
}

@Model
private final class SwiftDataHabit {
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
private final class SwiftDataHabitCompletion {
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
