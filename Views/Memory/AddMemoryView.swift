//
//  AddMemoryView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddMemoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var groups: [CrewGroup]

    @State private var selectedGroup: CrewGroup?
    @State private var date = Date()
    @State private var comment = ""
    @State private var expense = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?

    var body: some View {
        NavigationStack {
            Form {
                Section("그룹 선택") {
                    if groups.isEmpty {
                        Text("먼저 그룹을 만들어주세요")
                            .foregroundColor(.gray)
                    } else {
                        Picker("그룹", selection: $selectedGroup) {
                            Text("선택 안 함").tag(Optional<CrewGroup>.none)
                            ForEach(groups) { group in
                                Text(group.name).tag(Optional(group))
                            }
                        }
                    }
                }

                Section("날짜") {
                    DatePicker("날짜", selection: $date, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "ko_KR"))
                }

                Section("사진") {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        HStack {
                            if let photoData, let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Image(systemName: "photo.badge.plus")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                Text("사진 선택")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                photoData = data
                            }
                        }
                    }
                }

                Section("코멘트") {
                    TextField("이 날의 한줄 기록", text: $comment)
                }

                Section("지출 금액") {
                    HStack {
                        TextField("0", text: $expense)
                            .keyboardType(.numberPad)
                        Text("원")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("새 기록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        saveMemory()
                    }
                    .bold()
                }
            }
        }
    }

    private func saveMemory() {
        let newMemory = Memory(
            date: date,
            comment: comment,
            expense: Int(expense) ?? 0
        )
        newMemory.photoData = photoData
        newMemory.group = selectedGroup
        selectedGroup?.memories.append(newMemory)
        modelContext.insert(newMemory)
        HapticManager.success()
        dismiss()
    }
}
