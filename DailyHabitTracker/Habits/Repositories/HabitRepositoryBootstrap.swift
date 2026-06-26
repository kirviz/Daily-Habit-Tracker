//
//  HabitRepositoryBootstrap.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import Foundation

struct HabitRepositoryBootstrap {
    struct BootstrapResult {
        let repository: HabitRepository
        let startupError: Error?
    }

    static func makeRepository(useInMemoryRepository: Bool) -> BootstrapResult {
        do {
            let repository: HabitRepository

            if useInMemoryRepository {
                repository = InMemoryHabitRepository()
            } else {
                repository = try SwiftDataHabitRepository()
            }

            try HabitSeeder(repository: repository).seedDefaultHabitsIfNeeded()

            return BootstrapResult(repository: repository, startupError: nil)
        } catch {
            let fallbackRepository = InMemoryHabitRepository()
            try? HabitSeeder(repository: fallbackRepository).seedDefaultHabitsIfNeeded()

            return BootstrapResult(repository: fallbackRepository, startupError: error)
        }
    }
}
