//
//  Schedule.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import Foundation
import SwiftData

@Model
class Schedule {
    var id: UUID
    var date: Date
    var location: String
    var memo: String
    var isCompleted: Bool
    var group: CrewGroup?
    
    init(date: Date, location: String = "", memo: String = "") {
        self.id = UUID()
        self.date = date
        self.location = location
        self.memo = memo
        self.isCompleted = false
    }
}
