//
//  ContentView.swift
//  Daily Habit Tracker
//
//  Created by Darius on 16/06/2026.
//

import SwiftUI

struct Habit: Identifiable {
    let id = UUID()
    let name: String
    var isCompleted = false
}

private enum AppStyle {
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

    var body: some View {
        NavigationStack {
            List($habits) { $habit in
                HabitRow(name: habit.name, isCompleted: $habit.isCompleted)
            }
            .navigationTitle("Daily Habits")
        }
    }
}

private struct HabitRow: View {
    let name: String
    @Binding var isCompleted: Bool

    var body: some View {
        Button {
            isCompleted.toggle()
        } label: {
            HStack {
                Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isCompleted ? AppStyle.completedCheckbox : AppStyle.incompleteCheckbox)

                Text(name)
                    .foregroundStyle(AppStyle.habitName)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
