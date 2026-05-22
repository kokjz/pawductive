//
//  TaskItem.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

import Foundation
import SwiftData

@Model
final class TaskItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var expectedDurationInMinutes: Int
    var isCompleted: Bool
    var creationDate: Date
    
    init(title: String, expectedDurationInMinutes: Int) {
        self.id = UUID()
        self.title = title
        self.expectedDurationInMinutes = expectedDurationInMinutes
        self.isCompleted = false
        self.creationDate = Date()
    }
}
