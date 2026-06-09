//
//  Schedule.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Schedule.date) private var schedules: [Schedule]
    @Query(sort: \CrewGroup.createdAt) private var groups: [CrewGroup]
    @State private var showAddSchedule = false
    @State private var selectedGroup: CrewGroup? = nil

    var filteredSchedules: [Schedule] {
        if let group = selectedGroup {
            return schedules.filter { $0.group?.id == group.id }
        }
        return schedules
    }

    var upcomingSchedules: [Schedule] {
        filteredSchedules.filter { !$0.isCompleted && $0.date >= Date() }
    }

    var pastSchedules: [Schedule] {
        filteredSchedules.filter { $0.isCompleted || $0.date < Date() }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 그룹 필터 스크롤
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // 전체 버튼
                        FilterChip(
                            title: "전체",
                            color: "4F6BF6",
                            isSelected: selectedGroup == nil
                        ) {
                            selectedGroup = nil
                        }

                        ForEach(groups) { group in
                            FilterChip(
                                title: group.name,
                                color: group.colorTheme,
                                isSelected: selectedGroup?.id == group.id
                            ) {
                                selectedGroup = group
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(Color(.systemBackground))

                Divider()

                // 일정 목록
                List {
                    if !upcomingSchedules.isEmpty {
                        Section("다가오는 일정") {
                            ForEach(upcomingSchedules) { schedule in
                                ScheduleRowView(schedule: schedule)
                            }
                            .onDelete { offsets in
                                deleteSchedule(from: upcomingSchedules, at: offsets)
                            }
                        }
                    }

                    if !pastSchedules.isEmpty {
                        Section("지난 일정") {
                            ForEach(pastSchedules) { schedule in
                                ScheduleRowView(schedule: schedule)
                            }
                            .onDelete { offsets in
                                deleteSchedule(from: pastSchedules, at: offsets)
                            }
                        }
                    }

                    if filteredSchedules.isEmpty {
                        ContentUnavailableView(
                            "일정이 없어요",
                            systemImage: "calendar.badge.plus",
                            description: Text("+ 버튼을 눌러 일정을 추가해보세요")
                        )
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("일정")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSchedule = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "4F6BF6"))
                    }
                }
            }
            .sheet(isPresented: $showAddSchedule) {
                AddScheduleView()
            }
        }
    }

    private func deleteSchedule(from list: [Schedule], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(list[index])
        }
    }
}
