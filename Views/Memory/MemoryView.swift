//
//  MemoryView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI
import SwiftData

struct MemoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Memory.date, order: .reverse) private var memories: [Memory]
    @Query(sort: \CrewGroup.createdAt) private var groups: [CrewGroup]
    @State private var showAddMemory = false
    @State private var selectedGroup: CrewGroup? = nil

    var filteredMemories: [Memory] {
        if let group = selectedGroup {
            return memories.filter { $0.group?.id == group.id }
        }
        return memories
    }

    var groupedMemories: [(key: String, value: [Memory])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredMemories) { memory -> String in
            let components = calendar.dateComponents([.year, .month], from: memory.date)
            return "\(components.year!)년 \(components.month!)월"
        }
        return grouped.sorted { a, b in
            let aDate = filteredMemories.first { mem in
                let c = calendar.dateComponents([.year, .month], from: mem.date)
                return "\(c.year!)년 \(c.month!)월" == a.key
            }?.date ?? Date()
            let bDate = filteredMemories.first { mem in
                let c = calendar.dateComponents([.year, .month], from: mem.date)
                return "\(c.year!)년 \(c.month!)월" == b.key
            }?.date ?? Date()
            return aDate > bDate
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 그룹 필터 스크롤
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
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

                // 기록 목록
                if filteredMemories.isEmpty {
                    ContentUnavailableView(
                        "기록이 없어요",
                        systemImage: "photo.badge.plus",
                        description: Text("+ 버튼을 눌러 추억을 기록해보세요")
                    )
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                            ForEach(groupedMemories, id: \.key) { section in
                                Section {
                                    ForEach(section.value) { memory in
                                        MemoryCardView(memory: memory) {
                                            modelContext.delete(memory)
                                        }
                                        .padding(.horizontal)
                                        .padding(.bottom, 12)
                                    }
                                } header: {
                                    Text(section.key)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(.ultraThinMaterial)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("기록")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddMemory = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "4F6BF6"))
                    }
                }
            }
            .sheet(isPresented: $showAddMemory) {
                AddMemoryView()
            }
        }
    }
}
