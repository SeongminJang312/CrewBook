//
//  EditMemoryView.swift
//  CrewBook
//
//  Created by 장성민 on 6/9/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var groups: [CrewGroup]

    let memory: Memory

    @State private var date: Date
    @State private var comment: String
    @State private var expense: String
    @State private var selectedGroup: CrewGroup?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?

    init(memory: Memory) {
        self.memory = memory
        _date = State(initialValue: memory.date)
        _comment = State(initialValue: memory.comment)
        _expense = State(initialValue: memory.expense == 0 ? "" : "\(memory.expense)")
        _selectedGroup = State(initialValue: memory.group)
        _photoData = State(initialValue: memory.photoData)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("그룹 선택") {
                    Picker("그룹", selection: $selectedGroup) {
                        Text("선택 안 함").tag(Optional<CrewGroup>.none)
                        ForEach(groups) { group in
                            Text(group.name).tag(Optional(group))
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
                                Text("사진 변경")
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
            .navigationTitle("기록 수정")
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
                }
            }
        }
    }

    private func saveEdit() {
        memory.date = date
        memory.comment = comment
        memory.expense = Int(expense) ?? 0
        memory.photoData = photoData
        memory.group = selectedGroup
        HapticManager.success()
        dismiss()
    }
}
