//
//  StatsView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query(sort: \CrewGroup.createdAt) private var groups: [CrewGroup]
    @State private var selectedGroup: CrewGroup?

    var selectedGroupMemories: [Memory] {
        selectedGroup?.memories.sorted { $0.date < $1.date } ?? []
    }

    var monthlyData: [(month: String, count: Int)] {
        let calendar = Calendar.current
        var dict: [String: Int] = [:]
        for memory in selectedGroupMemories {
            let month = calendar.component(.month, from: memory.date)
            let key = "\(month)월"
            dict[key, default: 0] += 1
        }
        let sorted = dict.sorted { a, b in
            let aNum = Int(a.key.replacingOccurrences(of: "월", with: "")) ?? 0
            let bNum = Int(b.key.replacingOccurrences(of: "월", with: "")) ?? 0
            return aNum < bNum
        }
        return sorted.map { (month: $0.key, count: $0.value) }
    }

    var daysSinceFirst: Int? {
        guard let first = selectedGroupMemories.first?.date else { return nil }
        return Calendar.current.dateComponents([.day], from: first, to: Date()).day
    }

    var totalExpense: Int {
        selectedGroup?.memories.reduce(0) { $0 + $1.expense } ?? 0
    }

    var body: some View {
        NavigationStack {
            Group {
                if groups.isEmpty {
                    ContentUnavailableView(
                        "그룹이 없어요",
                        systemImage: "chart.bar",
                        description: Text("먼저 그룹을 만들어보세요")
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 16) {

                            // 그룹 필터 칩
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
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
                                .padding(.vertical, 6)
                            }

                            if let group = selectedGroup {

                                // 그룹 헤더 카드
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(Color(hex: group.colorTheme))
                                        .frame(width: 52, height: 52)
                                        .overlay {
                                            Text(String(group.name.prefix(1)))
                                                .font(.title2.bold())
                                                .foregroundColor(.white)
                                        }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(group.name)
                                            .font(.title3.bold())
                                        Text(group.members.isEmpty ? "멤버 없음" : group.members.joined(separator: " · "))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                }
                                .padding(16)
                                .background(Color(hex: group.colorTheme).opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.horizontal)

                                // 통계 카드 3개
                                HStack(spacing: 12) {
                                    StatsCardView(
                                        icon: "person.3.fill",
                                        iconColor: Color(hex: group.colorTheme),
                                        title: "총 모임",
                                        value: "\(group.memories.count)회"
                                    )
                                    StatsCardView(
                                        icon: "calendar.heart.fill",
                                        iconColor: .green,
                                        title: "첫 만남",
                                        value: daysSinceFirst.map { "D+\($0)" } ?? "-"
                                    )
                                    StatsCardView(
                                        icon: "wonsign.circle.fill",
                                        iconColor: .orange,
                                        title: "총 지출",
                                        value: "\(totalExpense.formatted())원"
                                    )
                                }
                                .padding(.horizontal)

                                // 월별 차트 카드
                                VStack(alignment: .leading, spacing: 14) {
                                    HStack {
                                        Image(systemName: "chart.bar.fill")
                                            .foregroundColor(Color(hex: group.colorTheme))
                                        Text("월별 모임 횟수")
                                            .font(.headline)
                                    }

                                    if monthlyData.isEmpty {
                                        VStack(spacing: 8) {
                                            Image(systemName: "chart.bar")
                                                .font(.system(size: 36))
                                                .foregroundColor(.gray.opacity(0.3))
                                            Text("아직 기록이 없어요")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 120)
                                    } else {
                                        Chart(monthlyData, id: \.month) { item in
                                            BarMark(
                                                x: .value("월", item.month),
                                                y: .value("횟수", item.count)
                                            )
                                            .foregroundStyle(Color(hex: group.colorTheme).gradient)
                                            .cornerRadius(6)
                                            .annotation(position: .top) {
                                                Text("\(item.count)")
                                                    .font(.caption2.bold())
                                                    .foregroundColor(Color(hex: group.colorTheme))
                                            }
                                        }
                                        .frame(height: 180)
                                        .chartYAxis(.hidden)
                                    }
                                }
                                .padding(16)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
                                .padding(.horizontal)

                                // 최근 기록 섹션
                                if !selectedGroupMemories.isEmpty {
                                    VStack(alignment: .leading, spacing: 14) {
                                        HStack {
                                            Image(systemName: "clock.fill")
                                                .foregroundColor(Color(hex: group.colorTheme))
                                            Text("최근 기록")
                                                .font(.headline)
                                        }

                                        ForEach(selectedGroupMemories.suffix(3).reversed()) { memory in
                                            HStack(spacing: 12) {
                                                Circle()
                                                    .fill(Color(hex: group.colorTheme).opacity(0.15))
                                                    .frame(width: 36, height: 36)
                                                    .overlay {
                                                        Image(systemName: "photo.fill")
                                                            .font(.caption)
                                                            .foregroundColor(Color(hex: group.colorTheme))
                                                    }
                                                VStack(alignment: .leading, spacing: 3) {
                                                    Text(memory.comment.isEmpty ? "기록 없음" : memory.comment)
                                                        .font(.subheadline)
                                                        .lineLimit(1)
                                                    Text(memory.date.formatted(.dateTime.year().month().day()))
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                                Spacer()
                                                if memory.expense > 0 {
                                                    Text("\(memory.expense.formatted())원")
                                                        .font(.caption.bold())
                                                        .foregroundColor(.orange)
                                                }
                                            }
                                        }
                                    }
                                    .padding(16)
                                    .background(Color(.systemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onAppear {
                        if selectedGroup == nil {
                            selectedGroup = groups.first
                        }
                    }
                }
            }
            .navigationTitle("통계")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct StatsCardView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
            Text(value)
                .font(.title3.bold())
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}
