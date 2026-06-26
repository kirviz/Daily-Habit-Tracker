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
        if ProcessInfo.processInfo.arguments.contains("--use-in-memory-repository") {
            repository = InMemoryHabitRepository()
        } else {
            do {
                repository = try SwiftDataHabitRepository()
            } catch {
                fatalError("Failed to create SwiftDataHabitRepository: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            HabitListView(repository: repository)
        }
    }
}
