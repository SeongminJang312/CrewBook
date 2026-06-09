//
//  GroupDetailView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI

struct GroupDetailView: View {
    let group: CrewGroup
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            // 상단 그룹 헤더
            VStack(spacing: 10) {
                Circle()
                    .fill(Color(hex: group.colorTheme))
                    .frame(width: 64, height: 64)
                    .overlay {
                        Text(String(group.name.prefix(1)))
                            .font(.title.bold())
                            .foregroundColor(.white)
                    }
                Text(group.name)
                    .font(.title2.bold())
                if !group.members.isEmpty {
                    Text(group.members.joined(separator: " · "))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color(hex: group.colorTheme).opacity(0.08))

            // 세그먼트 탭
            Picker("", selection: $selectedTab) {
                Text("일정").tag(0)
                Text("기록").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 12)

            // 탭 콘텐츠
            if selectedTab == 0 {
                GroupScheduleListView(group: group)
            } else {
                GroupMemoryListView(group: group)
            }
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 그룹별 일정 목록
struct GroupScheduleListView: View {
    let group: CrewGroup

    var sortedSchedules: [Schedule] {
        group.schedules.sorted { $0.date < $1.date }
    }

    var body: some View {
        if sortedSchedules.isEmpty {
            ContentUnavailableView(
                "일정이 없어요",
                systemImage: "calendar.badge.plus",
                description: Text("일정 탭에서 이 그룹의 일정을 추가해보세요")
            )
        } else {
            List(sortedSchedules) { schedule in
                ScheduleRowView(schedule: schedule)
            }
            .listStyle(.plain)
        }
    }
}

// 그룹별 기록 목록
struct GroupMemoryListView: View {
    let group: CrewGroup

    var sortedMemories: [Memory] {
        group.memories.sorted { $0.date > $1.date }
    }

    var body: some View {
        if sortedMemories.isEmpty {
            ContentUnavailableView(
                "기록이 없어요",
                systemImage: "photo.badge.plus",
                description: Text("기록 탭에서 이 그룹의 추억을 추가해보세요")
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(sortedMemories) { memory in
                        MemoryCardView(memory: memory) {}
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
