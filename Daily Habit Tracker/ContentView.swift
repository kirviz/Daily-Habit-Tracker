//
//  ContentView.swift
//  Daily Habit Tracker
//
//  Created by Darius on 16/06/2026.
//

import SwiftUI

enum AppStyle {
    static let habitName = Color(.label)
    static let completedCheckbox = Color.green
    static let incompleteCheckbox = Color(.tertiaryLabel)
}

struct ContentView: View {
    @State private var habits = [
        Habit(name: "Walk"),
        Habit(name: "Meditation"),
        Habit(name: "Gym")
    ]
    @State private var isShowingAddHabit = false

    var body: some View {
        NavigationStack {
            List($habits) { $habit in
                HabitRowView(name: habit.name, isCompleted: $habit.isCompleted)
            }
            .navigationTitle("Daily Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddHabit) {
                AddHabitView { habitName in
                    habits.append(Habit(name: habitName))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
