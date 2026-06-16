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
    @State private var isShowingAddHabit = false

    var body: some View {
        NavigationStack {
            List($habits) { $habit in
                HabitRow(name: habit.name, isCompleted: $habit.isCompleted)
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

private struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var habitName = ""
    @FocusState private var isHabitNameFocused: Bool

    let onSave: (String) -> Void

    private var trimmedHabitName: String {
        habitName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func saveHabit() {
        guard !trimmedHabitName.isEmpty else { return }

        onSave(trimmedHabitName)
        dismiss()
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit name", text: $habitName)
                    .focused($isHabitNameFocused)
                    .onSubmit(saveHabit)
            }
            .navigationTitle("New Habit")
            .onAppear {
                isHabitNameFocused = true
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveHabit)
                        .disabled(trimmedHabitName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
