//
//  GroupRowView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI

struct GroupRowView: View {
    let group: CrewGroup

    var body: some View {
        HStack(spacing: 14) {
            // 색상 원
            Circle()
                .fill(Color(hex: group.colorTheme))
                .frame(width: 46, height: 46)
                .overlay {
                    Text(String(group.name.prefix(1)))
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.headline)
                Text(group.members.isEmpty ? "멤버 없음" : group.members.joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("멤버 \(group.members.count)명")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(group.createdAt.formatted(.dateTime.month().day()))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 6)
    }
}
