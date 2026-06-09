//
//  ContentView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
            
            ScheduleView()
                .tabItem {
                    Label("일정", systemImage: "calendar")
                }
            
            MemoryView()
                .tabItem {
                    Label("기록", systemImage: "photo.fill")
                }
            
            StatsView()
                .tabItem {
                    Label("통계", systemImage: "chart.bar.fill")
                }
        }
        .tint(Color("MainColor"))
    }
}
