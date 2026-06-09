//
//  SampleData.swift
//  CrewBook
//
//  Created by 장성민 on 6/9/26.
//

import SwiftData
import UIKit

struct SampleData {
    static func insert(into context: ModelContext) {
        // 이미 데이터 있으면 스킵
        let descriptor = FetchDescriptor<CrewGroup>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        let calendar = Calendar.current
        let now = Date()

        func daysAgo(_ n: Int) -> Date {
            calendar.date(byAdding: .day, value: -n, to: now) ?? now
        }
        func daysLater(_ n: Int) -> Date {
            calendar.date(byAdding: .day, value: n, to: now) ?? now
        }

        // ── 그룹 1: 금요 술친구 ──────────────────
        let g1 = CrewGroup(name: "금요 술친구", members: ["성민", "진호", "수빈", "태양"], colorTheme: "ef4444")
        context.insert(g1)

        let s1 = Schedule(date: daysLater(3), location: "홍대 포장마차", memo: "2차는 노래방")
        s1.group = g1
        g1.schedules.append(s1)
        context.insert(s1)

        let s2 = Schedule(date: daysLater(17), location: "신촌 맥줏집", memo: "")
        s2.group = g1
        g1.schedules.append(s2)
        context.insert(s2)

        let s3 = Schedule(date: daysAgo(14), location: "강남 이자카야", memo: "다음엔 홍대로")
        s3.isCompleted = true
        s3.group = g1
        g1.schedules.append(s3)
        context.insert(s3)

        let m1 = Memory(date: daysAgo(14), comment: "오늘도 너무 즐거웠다 🍺", expense: 35000)
        m1.group = g1
        m1.photoData = UIImage(systemName: "figure.socialdance")?.pngData()
        g1.memories.append(m1)
        context.insert(m1)

        let m2 = Memory(date: daysAgo(45), comment: "첫 모임! 다들 너무 웃겼어 ㅋㅋ", expense: 28000)
        m2.group = g1
        g1.memories.append(m2)
        context.insert(m2)

        // ── 그룹 2: 게임 모임 ───────────────────
        let g2 = CrewGroup(name: "게임 모임", members: ["성민", "재원", "민준"], colorTheme: "4F6BF6")
        context.insert(g2)

        let s4 = Schedule(date: daysLater(10), location: "건대 PC방", memo: "롤 5:5 내전")
        s4.group = g2
        g2.schedules.append(s4)
        context.insert(s4)

        let s5 = Schedule(date: daysAgo(7), location: "신림 PC방", memo: "")
        s5.isCompleted = true
        s5.group = g2
        g2.schedules.append(s5)
        context.insert(s5)

        let m3 = Memory(date: daysAgo(7), comment: "오늘 MVP는 나 😎", expense: 15000)
        m3.group = g2
        g2.memories.append(m3)
        context.insert(m3)

        let m4 = Memory(date: daysAgo(30), comment: "첫 내전 대패... 다음엔 이긴다", expense: 12000)
        m4.group = g2
        g2.memories.append(m4)
        context.insert(m4)

        let m5 = Memory(date: daysAgo(60), comment: "새벽 6시까지 했다 ㅋㅋㅋ", expense: 18000)
        m5.group = g2
        g2.memories.append(m5)
        context.insert(m5)

        // ── 그룹 3: 밴드 동아리 ─────────────────
        let g3 = CrewGroup(name: "밴드 동아리", members: ["성민", "하늘", "안서", "지훈", "예린", "민재"], colorTheme: "10b981")
        context.insert(g3)

        let s6 = Schedule(date: daysLater(5), location: "학교 합주실", memo: "버스킹 준비 마무리")
        s6.group = g3
        g3.schedules.append(s6)
        context.insert(s6)

        let s7 = Schedule(date: daysLater(25), location: "홍대 버스킹 광장", memo: "드디어 첫 버스킹!")
        s7.group = g3
        g3.schedules.append(s7)
        context.insert(s7)

        let s8 = Schedule(date: daysAgo(10), location: "학교 합주실", memo: "")
        s8.isCompleted = true
        s8.group = g3
        g3.schedules.append(s8)
        context.insert(s8)

        let m6 = Memory(date: daysAgo(10), comment: "합주 3시간, 땀범벅이지만 행복 🎸", expense: 0)
        m6.group = g3
        g3.memories.append(m6)
        context.insert(m6)

        let m7 = Memory(date: daysAgo(40), comment: "첫 합주날 😊 다들 어색했지만 재밌었어", expense: 0)
        m7.group = g3
        g3.memories.append(m7)
        context.insert(m7)

        // ── 그룹 4: 술악속 ──────────────────────
        let g4 = CrewGroup(name: "술악속", members: ["성민", "장우"], colorTheme: "8b5cf6")
        context.insert(g4)

        let s9 = Schedule(date: daysLater(1), location: "홍대", memo: "죽지말것")
        s9.group = g4
        g4.schedules.append(s9)
        context.insert(s9)

        let m8 = Memory(date: daysAgo(3), comment: "즐거웠다 🎵", expense: 20300)
        m8.group = g4
        g4.memories.append(m8)
        context.insert(m8)

        try? context.save()
    }
}
