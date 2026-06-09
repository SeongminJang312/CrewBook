//
//  CrewBookApp.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI
import SwiftData

@main
struct CrewBookApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // 샘플 데이터 삽입
                }
        }
        .modelContainer(for: [CrewGroup.self, Schedule.self, Memory.self]) { result in
            guard let container = try? result.get() else { return }
            SampleData.insert(into: container.mainContext)
        }
    }
}
