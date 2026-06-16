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
                Button {
                    habit.isCompleted.toggle()
                } label: {
                    HStack {
                        Image(systemName: habit.isCompleted ? "checkmark.square.fill" : "square")
                            .foregroundStyle(habit.isCompleted ? AppStyle.completedCheckbox : AppStyle.incompleteCheckbox)

                        Text(habit.name)
                            .foregroundStyle(AppStyle.habitName)
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Daily Habits")
        }
    }
}

#Preview {
    ContentView()
}
