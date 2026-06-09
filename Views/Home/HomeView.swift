//
//  HomeView.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CrewGroup.createdAt, order: .reverse) private var groups: [CrewGroup]
    @State private var showAddGroup = false

    var body: some View {
        NavigationStack {
            ScrollView {
                if groups.isEmpty {
                    VStack(spacing: 16) {
                        Spacer().frame(height: 80)
                        Image(systemName: "person.3")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("아직 그룹이 없어요")
                            .font(.title3.bold())
                            .foregroundColor(.gray)
                        Text("+ 버튼을 눌러 첫 모임을 만들어보세요")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(groups) { group in
                            NavigationLink {
                                GroupDetailView(group: group)
                            } label: {
                                GroupCardView(group: group) {
                                    modelContext.delete(group)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("CrewBook")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddGroup = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "4F6BF6"))
                    }
                }
            }
            .sheet(isPresented: $showAddGroup) {
                AddGroupView()
            }
        }
    }
}
