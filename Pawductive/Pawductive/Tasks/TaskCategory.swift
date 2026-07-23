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
    
    init(name: String, iconName: String = "📁") {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
    }
    
    static var defaults: [TaskCategory] {
        [
            TaskCategory(name: "Study", iconName: "📚"),
            TaskCategory(name: "Work", iconName: "💼"),
            TaskCategory(name: "Fitness", iconName: "🏃"),
            TaskCategory(name: "Leisure", iconName: "🎮"),
            TaskCategory(name: "General", iconName: "📁")
        ]
    }
}
