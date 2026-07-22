//
//  TaskCategory.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/7/26.
//

import Foundation
import SwiftData

@Model
final class TaskCategory {
    @Attribute(.unique) var id: UUID
    var name: String
    var iconName: String
    
    init(name: String, iconName: String = "folder.fill") {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
    }
    
    static var defaults: [TaskCategory] {
        [
            TaskCategory(name: "Study", iconName: "book.fill"),
            TaskCategory(name: "Work", iconName: "briefcase.fill"),
            TaskCategory(name: "Fitness", iconName: "figure.run"),
            TaskCategory(name: "Leisure", iconName: "gamecontroller.fill"),
            TaskCategory(name: "General", iconName: "folder.fill")
        ]
    }
}
