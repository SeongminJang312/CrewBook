//
//  GroupCardView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI

struct GroupCardView: View {
    let group: CrewGroup
    let onDelete: () -> Void
    @State private var showDeleteAlert = false
    @State private var showEdit = false

    var lastMemoryDate: String {
        guard let last = group.memories.sorted(by: { $0.date > $1.date }).first else {
            return "기록 없음"
        }
        return last.date.formatted(.dateTime.year().month().day())
    }

    var nextSchedule: String {
        let upcoming = group.schedules
            .filter { !$0.isCompleted && $0.date >= Date() }
            .sorted { $0.date < $1.date }
        guard let next = upcoming.first else { return "예정 없음" }
        return next.date.formatted(.dateTime.month().day().hour().minute())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 상단 헤더
            HStack(spacing: 14) {
                Circle()
                    .fill(Color(hex: group.colorTheme))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(String(group.name.prefix(1)))
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }

                VStack(alignment: .leading, spacing: 3) {
                    Text(group.name)
                        .font(.title3.bold())
                    Text(group.members.isEmpty ? "멤버 없음" : group.members.joined(separator: " · "))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Spacer()

                Text("멤버 \(group.members.count)명")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(hex: group.colorTheme))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)

            Divider()
                .padding(.horizontal, 18)
                .padding(.vertical, 12)

            // 하단 정보
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Label("다음 일정", systemImage: "calendar")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text(nextSchedule)
                        .font(.caption.bold())
                        .foregroundColor(nextSchedule == "예정 없음" ? .gray : Color(hex: "4F6BF6"))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Label("마지막 기록", systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text(lastMemoryDate)
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color(hex: group.colorTheme).opacity(0.15), radius: 10, x: 0, y: 4)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .contextMenu {
            Button {
                showEdit = true
            } label: {
                Label("그룹 수정", systemImage: "pencil")
            }
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("그룹 삭제", systemImage: "trash")
            }
        }
        .alert("그룹 삭제", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) { onDelete() }
        } message: {
            Text("'\(group.name)' 그룹과 모든 기록이 삭제돼요.")
        }
        .sheet(isPresented: $showEdit) {
            EditGroupView(group: group)
        }
    }
}
