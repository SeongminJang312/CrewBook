//
//  FilterChip.swift
//  CrewBook
//
//  Created by 장성민 on 6/9/26.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let color: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if isSelected {
                    Circle()
                        .fill(Color(hex: color))
                        .frame(width: 7, height: 7)
                }
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(isSelected ? Color(hex: color) : .gray)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                isSelected
                ? Color(hex: color).opacity(0.12)
                : Color(.systemGray6)
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color(hex: color).opacity(0.4) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
