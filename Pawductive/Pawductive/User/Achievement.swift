//
//  Achievement.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 15/6/26.
//

import Foundation

enum Achievement: String, CaseIterable, Identifiable {
    //achievements
    case testTaskAchievement
    case testTimeAchievement
    
    var id: String { self.rawValue }
    
    //achievement titles
    var title: String {
        switch self {
        case.testTaskAchievement: return "Test Task Achievement"
        case.testTimeAchievement: return "Test Time Achievement"
        }
    }
    
    //unlock descriptions
    var requirementDescription: String {
        switch self {
        case.testTaskAchievement: return "Test Task Achievement Description"
        case.testTimeAchievement: return "Test Time Achievement Description"
        }
    }
    
    //unlock eval logic
    func isunlocked(stats: UserStats) -> Bool {
        switch self {
        case.testTaskAchievement: return stats.totalTasksCompleted >= 1
        case.testTimeAchievement: return stats.totalMinutesFocused >= 1
        }
    }
}
