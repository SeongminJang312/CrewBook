//
//  Group.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//
import Foundation
import SwiftData

@Model
class CrewGroup {
    var id: UUID
    var name: String
    var members: [String]
    var colorTheme: String
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade) var schedules: [Schedule] = []
    @Relationship(deleteRule: .cascade) var memories: [Memory] = []
    
    init(name: String, members: [String] = [], colorTheme: String = "indigo") {
        self.id = UUID()
        self.name = name
        self.members = members
        self.colorTheme = colorTheme
        self.createdAt = Date()
    }
}
