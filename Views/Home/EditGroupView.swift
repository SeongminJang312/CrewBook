//
//  EditGroupView.swift
//  CrewBook
//
//  Created by 장성민 on 6/9/26.
//

import SwiftUI

struct EditGroupView: View {
    @Environment(\.dismiss) private var dismiss

    let group: CrewGroup

    @State private var groupName: String
    @State private var memberInput = ""
    @State private var members: [String]
    @State private var selectedColor: String

    let colorOptions = [
        "4F6BF6", "ef4444", "10b981",
        "f59e0b", "8b5cf6", "ec4899"
    ]

    init(group: CrewGroup) {
        self.group = group
        _groupName = State(initialValue: group.name)
        _members = State(initialValue: group.members)
        _selectedColor = State(initialValue: group.colorTheme)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("그룹 이름") {
                    TextField("예) 금요 술친구", text: $groupName)
                }

                Section("테마 색상") {
                    HStack(spacing: 12) {
                        ForEach(colorOptions, id: \.self) { color in
                            colorCircle(color: color)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("멤버") {
                    HStack {
                        TextField("이름 입력", text: $memberInput)
                        Button("추가") {
                            let trimmed = memberInput.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty {
                                members.append(trimmed)
                                memberInput = ""
                            }
                        }
                        .disabled(memberInput.trimmingCharacters(in: .whitespaces).isEmpty)
                    }

                    ForEach(members, id: \.self) { member in
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(hex: selectedColor))
                            Text(member)
                        }
                    }
                    .onDelete { offsets in
                        members.remove(atOffsets: offsets)
                    }
                }
            }
            .navigationTitle("그룹 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        saveEdit()
                    }
                    .bold()
                    .disabled(groupName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func colorCircle(color: String) -> some View {
        Circle()
            .fill(Color(hex: color))
            .frame(width: 32, height: 32)
            .overlay {
                if selectedColor == color {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.caption.bold())
                }
            }
            .onTapGesture {
                selectedColor = color
            }
    }

    private func saveEdit() {
        group.name = groupName.trimmingCharacters(in: .whitespaces)
        group.members = members
        group.colorTheme = selectedColor
        HapticManager.success()
        dismiss()
    }
}
