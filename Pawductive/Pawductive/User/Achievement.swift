//
//  Achievement.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 15/6/26.
//

import Foundation

enum Achievement: String, CaseIterable, Identifiable {
    //achievements
    case OneTaskAchievement
    case FiveTasksAchievement
    case TenTasksAchievement
    case OneMinAchievement
    case ThirtyMinAchievement
    case OneHourAchievement
    
    var id: String { self.rawValue }
    
    //achievement titles
    var title: String {
        switch self {
        case.OneTaskAchievement: return "New Worker"
        case.FiveTasksAchievement: return "Nine to Five"
        case.TenTasksAchievement: return "Workaholic"
        case.OneMinAchievement: return "Clocking In"
        case.ThirtyMinAchievement: return "Half Hour Hero"
        case.OneHourAchievement: return "Overtime"
        }
    }
    
    //unlock descriptions
    var requirementDescription: String {
        switch self {
        case.OneTaskAchievement: return "Complete 1 task"
        case.FiveTasksAchievement: return "Complete 5 tasks"
        case.TenTasksAchievement: return "Complete 10 tasks"
        case.OneMinAchievement: return "Focus for 1 minute"
        case.ThirtyMinAchievement: return "Focus for 30 minutes"
        case.OneHourAchievement: return "Focus for 1 hour"
        }
    }
    
    //unlock eval logic
    func isUnlocked(stats: UserStats) -> Bool {
        switch self {
        case.OneTaskAchievement: return stats.totalTasksCompleted >= 1
        case.FiveTasksAchievement: return stats.totalTasksCompleted >= 5
        case.TenTasksAchievement: return stats.totalTasksCompleted >= 10
        case.OneMinAchievement: return stats.totalMinutesFocused >= 1
        case.ThirtyMinAchievement: return stats.totalMinutesFocused >= 30
        case.OneHourAchievement: return stats.totalMinutesFocused >= 60
        }
    }
}
