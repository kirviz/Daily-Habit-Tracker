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
    private let startupError: Error?

    init() {
        let bootstrapResult = HabitRepositoryBootstrap.makeRepository(
            useInMemoryRepository: ProcessInfo.processInfo.arguments.contains("--use-in-memory-repository")
        )

        repository = bootstrapResult.repository
        startupError = bootstrapResult.startupError
    }

    var body: some Scene {
        WindowGroup {
            HabitListView(repository: repository, startupError: startupError)
        }
    }
}
