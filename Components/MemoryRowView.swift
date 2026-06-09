//
//  MemoryRowView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI

struct MemoryRowView: View {
    let memory: Memory

    var body: some View {
        HStack(spacing: 14) {
            // 사진 썸네일
            if let photoData = memory.photoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            }

            VStack(alignment: .leading, spacing: 5) {
                // 그룹명
                if let group = memory.group {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color(hex: group.colorTheme))
                            .frame(width: 8, height: 8)
                        Text(group.name)
                            .font(.caption)
                            .foregroundColor(Color(hex: group.colorTheme))
                    }
                }
                // 날짜
                Text(memory.date.formatted(.dateTime.year().month().day()))
                    .font(.headline)
                // 코멘트
                if !memory.comment.isEmpty {
                    Text(memory.comment)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                // 지출
                if memory.expense > 0 {
                    Label("\(memory.expense.formatted())원", systemImage: "wonsign.circle")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
