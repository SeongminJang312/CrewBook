//
//  AddGroupView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var groupName = ""
    @State private var memberInput = ""
    @State private var members: [String] = []
    @State private var selectedColor = "4F6BF6"

    let colorOptions = [
        "4F6BF6", "ef4444", "10b981",
        "f59e0b", "8b5cf6", "ec4899"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("그룹 이름") {
                    TextField("예) 금요 술친구", text: $groupName)
                }

                Section("테마 색상") {
                    HStack(spacing: 12) {
                        ForEach(colorOptions, id: \.self) { color in
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
                    }
                    .padding(.vertical, 4)
                }

                Section("멤버 추가") {
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
            .navigationTitle("새 그룹")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        saveGroup()
                    }
                    .bold()
                    .disabled(groupName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveGroup() {
        let newGroup = CrewGroup(
            name: groupName.trimmingCharacters(in: .whitespaces),
            members: members,
            colorTheme: selectedColor
        )
        modelContext.insert(newGroup)
        HapticManager.success()
        dismiss()
    }}
