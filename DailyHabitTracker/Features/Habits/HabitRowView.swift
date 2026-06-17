//
//  HabitRowView.swift
//  DailyHabitTracker
//
//  Created by Darius on 16/06/2026.
//

import SwiftUI

struct HabitRowView<Destination: View>: View {
    let name: String
    let isCompleted: Bool
    let toggleCompletion: () -> Void
    @ViewBuilder let destination: () -> Destination

    var body: some View {
        HStack(spacing: 12) {
            Button {
                toggleCompletion()
            } label: {
                HStack {
                    Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                        .foregroundStyle(isCompleted ? AppStyle.completedCheckbox : AppStyle.incompleteCheckbox)
                    
                    Text(name)
                        .foregroundStyle(AppStyle.habitName)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isCompleted ? "Mark \(name) incomplete" : "Mark \(name) complete")

            NavigationLink {
                destination()
            } label: {
                HStack {

                    Spacer()

                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}
