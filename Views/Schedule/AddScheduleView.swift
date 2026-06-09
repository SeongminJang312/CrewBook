//
//  AddScheduleView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI
import SwiftData

struct AddScheduleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var groups: [CrewGroup]

    @State private var selectedGroup: CrewGroup?
    @State private var date = Date()
    @State private var location = ""
    @State private var memo = ""

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
            .navigationTitle("새 일정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        saveSchedule()
                    }
                    .bold()
                }
            }
        }
    }

    private func saveSchedule() {
        let newSchedule = Schedule(date: date, location: location, memo: memo)
        newSchedule.group = selectedGroup
        selectedGroup?.schedules.append(newSchedule)
        modelContext.insert(newSchedule)
        HapticManager.success()
        dismiss()
    }
}
