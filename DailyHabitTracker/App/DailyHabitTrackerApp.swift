//
//  DailyHabitTrackerApp.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import SwiftUI

@main
struct DailyHabitTrackerApp: App {
    private let repository: HabitRepository

    init() {
        do {
            if ProcessInfo.processInfo.arguments.contains("--use-in-memory-repository") {
                let inMemoryRepository = InMemoryHabitRepository()
                try HabitSeeder(repository: inMemoryRepository).seedDefaultHabitsIfNeeded()
                repository = inMemoryRepository
            } else {
                let swiftDataRepository = try SwiftDataHabitRepository()
                try HabitSeeder(repository: swiftDataRepository).seedDefaultHabitsIfNeeded()
                repository = swiftDataRepository
            }
        } catch {
            fatalError("Failed to prepare habit repository: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            HabitListView(repository: repository)
        }
    }
}
