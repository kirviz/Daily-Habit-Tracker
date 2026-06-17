//
//  ContentView.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import SwiftUI

enum AppStyle {
    static let habitName = Color(.label)
    static let completedCheckbox = Color.green
    static let incompleteCheckbox = Color(.tertiaryLabel)
}

struct HabitListView: View {
    @State private var viewModel = HabitListViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.habits) { habit in
                    HabitRowView(
                        name: habit.name,
                        isCompleted: viewModel.isCompletedToday(habit),
                        toggleCompletion: {
                            viewModel.toggleTodayCompletion(for: habit)
                        }
                    )
                }
                .onDelete(perform: viewModel.deleteHabits)
            }
            .navigationTitle("Daily Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isShowingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingAddHabit) {
                AddHabitView { habitName in
                    viewModel.addHabit(named: habitName)
                }
            }
        }
    }
}

#Preview {
    HabitListView()
}
