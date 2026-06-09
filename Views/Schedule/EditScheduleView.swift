//
//  EditScheduleView.swift
//  CrewBook
//
//  Created by 장성민 on 6/9/26.
//

import SwiftUI
import SwiftData

struct EditScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var groups: [CrewGroup]

    let schedule: Schedule

    @State private var date: Date
    @State private var location: String
    @State private var memo: String
    @State private var selectedGroup: CrewGroup?

    init(schedule: Schedule) {
        self.schedule = schedule
        _date = State(initialValue: schedule.date)
        _location = State(initialValue: schedule.location)
        _memo = State(initialValue: schedule.memo)
        _selectedGroup = State(initialValue: schedule.group)
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

                Section("날짜 & 시간") {
                    DatePicker("날짜", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .environment(\.locale, Locale(identifier: "ko_KR"))
                }

                Section("장소") {
                    TextField("예) 홍대 OO식당", text: $location)
                }

                Section("메모") {
                    TextField("간단한 메모", text: $memo)
                }
            }
            .navigationTitle("일정 수정")
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
        schedule.date = date
        schedule.location = location
        schedule.memo = memo
        schedule.group = selectedGroup
        HapticManager.success()
        dismiss()
    }
}
