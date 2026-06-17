//
//  HabitRowView.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import SwiftUI

struct HabitRowView: View {
    let name: String
    let isCompleted: Bool
    let toggleCompletion: () -> Void

    var body: some View {
        Button {
            toggleCompletion()
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
