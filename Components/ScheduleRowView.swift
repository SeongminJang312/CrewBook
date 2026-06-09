//
//  ScheduleRowView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI

struct ScheduleRowView: View {
    let schedule: Schedule
    @State private var showEdit = false

    var body: some View {
        HStack(spacing: 14) {
            Button {
                withAnimation {
                    schedule.isCompleted.toggle()
                    HapticManager.light()
                }
            } label: {
                Image(systemName: schedule.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(schedule.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if let group = schedule.group {
                        Circle()
                            .fill(Color(hex: group.colorTheme))
                            .frame(width: 8, height: 8)
                        Text(group.name)
                            .font(.caption)
                            .foregroundColor(Color(hex: group.colorTheme))
                    }
                }
                Text(schedule.date.formatted(.dateTime.month().day().hour().minute()))
                    .font(.headline)
                    .strikethrough(schedule.isCompleted)
                    .foregroundColor(schedule.isCompleted ? .gray : .primary)

                if !schedule.location.isEmpty {
                    Label(schedule.location, systemImage: "mappin")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                if !schedule.memo.isEmpty {
                    Text(schedule.memo)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button {
                showEdit = true
            } label: {
                Image(systemName: "pencil.circle")
                    .font(.title2)
                    .foregroundColor(.gray.opacity(0.6))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .opacity(schedule.isCompleted ? 0.6 : 1.0)
        .sheet(isPresented: $showEdit) {
            EditScheduleView(schedule: schedule)
        }
    }
}
