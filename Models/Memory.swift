//
//  Memory.swift
//  CrewBook
//
//  Created by 장성민 on 6/8/26.
//

import Foundation
import SwiftData

@Model
class Memory {
    var id: UUID
    var date: Date
    var photoData: Data?
    var comment: String
    var expense: Int
    var group: CrewGroup?
    
    init(date: Date, comment: String = "", expense: Int = 0) {
        self.id = UUID()
        self.date = date
        self.comment = comment
        self.expense = expense
    }
}
