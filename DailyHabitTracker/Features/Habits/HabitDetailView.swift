//
//  HabitDetailView.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import SwiftUI

struct HabitDetailView: View {
    let habit: Habit
    let viewModel: HabitListViewModel

    private let dayCount = 7

    var body: some View {
        List {
            Section("Last 7 Days") {
                ForEach(Array(viewModel.recentDates(count: dayCount).enumerated()), id: \.element) { index, date in
                    Button {
                        viewModel.toggleCompletion(for: habit, on: date)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(date, format: .dateTime.weekday(.wide))
                                    .font(.body)

                                Text(date, format: .dateTime.month().day())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            completionImage(for: date)
                        }.contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(completionToggleAccessibilityLabel(for: date))
                    .accessibilityIdentifier("habit-history-row-\(index)")
                    .accessibilityValue(completionAccessibilityValue(for: date))
                }
            }
        }
        .navigationTitle(habit.name)
    }

    private func completionImage(for date: Date) -> some View {
        let isCompleted = viewModel.isCompleted(habit, on: date)

        return Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
            .foregroundStyle(isCompleted ? AppStyle.completedCheckbox : AppStyle.incompleteCheckbox)
            .accessibilityLabel(isCompleted ? "Completed" : "Not completed")
    }

    private func completionToggleAccessibilityLabel(for date: Date) -> String {
        let isCompleted = viewModel.isCompleted(habit, on: date)
        let action = isCompleted ? "Mark incomplete" : "Mark complete"
        let formattedDate = date.formatted(.dateTime.month().day())

        return "\(action) for \(formattedDate)"
    }

    private func completionAccessibilityValue(for date: Date) -> String {
        viewModel.isCompleted(habit, on: date) ? "Completed" : "Not completed"
    }
}

#Preview {
    let habit = Habit(name: "Read")
    let today = Date()

    NavigationStack {
        HabitDetailView(
            habit: habit,
            viewModel: HabitListViewModel(
                habits: [habit],
                completions: [HabitCompletion(habitID: habit.id, date: today)],
                today: { today }
            )
        )
    }
}
