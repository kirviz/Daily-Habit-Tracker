//
//  AddHabitView.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import SwiftUI

struct AddHabitView: View {
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
