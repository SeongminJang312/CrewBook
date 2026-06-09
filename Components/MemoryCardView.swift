//
//  MemoryCardView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI

struct MemoryCardView: View {
    let memory: Memory
    let onDelete: () -> Void
    @State private var showDeleteAlert = false
    @State private var showEdit = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 사진
            if let photoData = memory.photoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 8) {
                // 그룹 + 날짜
                HStack {
                    if let group = memory.group {
                        HStack(spacing: 5) {
                            Circle()
                                .fill(Color(hex: group.colorTheme))
                                .frame(width: 8, height: 8)
                            Text(group.name)
                                .font(.caption.bold())
                                .foregroundColor(Color(hex: group.colorTheme))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: group.colorTheme).opacity(0.1))
                        .clipShape(Capsule())
                    }
                    Spacer()
                    Text(memory.date.formatted(.dateTime.year().month().day()))
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // 코멘트
                if !memory.comment.isEmpty {
                    Text(memory.comment)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }

                // 지출
                if memory.expense > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "wonsign.circle.fill")
                            .foregroundColor(.orange)
                        Text("\(memory.expense.formatted())원")
                            .font(.caption.bold())
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(14)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
        .contextMenu {
            Button {
                showEdit = true
            } label: {
                Label("기록 수정", systemImage: "pencil")
            }
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("기록 삭제", systemImage: "trash")
            }
        }
        .alert("기록 삭제", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) { onDelete() }
        } message: {
            Text("이 기록을 삭제할까요?")
        }
        .sheet(isPresented: $showEdit) {
            EditMemoryView(memory: memory)
        }
    }
}
