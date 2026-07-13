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
    case GiveFoodAchievement_3
    case GiveFoodAchievement_30
    case GiveFoodAchievement_300
    case GiveToysAchievement_3
    case GiveToysAchievement_30
    case GiveToysAchievement_300
    case MoodStreakAchievement_3
    case MoodStreakAchievement_30
    case MoodStreakAchievement_300
    case EnergyStreakAchievement_3
    case EnergyStreakAchievement_30
    case EnergyStreakAchievement_300
    
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
        case.GiveFoodAchievement_3: return "First Bite"
        case.GiveFoodAchievement_30: return "Regular Meals"
        case.GiveFoodAchievement_300: return "Royal Banquet"
        case.GiveToysAchievement_3: return "Toy Box"
        case.GiveToysAchievement_30: return "Toy Enthusiast"
        case.GiveToysAchievement_300: return "Toy Collector"
        case.MoodStreakAchievement_3: return "Bright Days"
        case.MoodStreakAchievement_30: return "Bundle of Joy"
        case.MoodStreakAchievement_300: return "Ray of Sunshine"
        case.EnergyStreakAchievement_3: return "Energized"
        case.EnergyStreakAchievement_30: return "Wide Awake"
        case.EnergyStreakAchievement_300: return "Never Tired"
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
        case.GiveFoodAchievement_3: return "Give 3 food"
        case.GiveFoodAchievement_30: return "Give 30 food"
        case.GiveFoodAchievement_300: return "Give 300 food"
        case.GiveToysAchievement_3: return "Give 3 toys"
        case.GiveToysAchievement_30: return "Give 30 toys"
        case.GiveToysAchievement_300: return "Give 300 toys"
        case.MoodStreakAchievement_3: return "Keep mood high for 3 days"
        case.MoodStreakAchievement_30: return "Keep mood high for 30 days"
        case.MoodStreakAchievement_300: return "Keep mood high for 300 days"
        case.EnergyStreakAchievement_3: return "Keep energy high for 3 days"
        case.EnergyStreakAchievement_30: return "Keep energy high for 30 days"
        case.EnergyStreakAchievement_300: return "Keep energy high for 300 days"
        }
    }
    
    //unlock eval logic
    func isUnlocked(stats: UserStats, pet: Pet) -> Bool {
        switch self {
        case.OneTaskAchievement: return stats.totalTasksCompleted >= 1
        case.FiveTasksAchievement: return stats.totalTasksCompleted >= 5
        case.TenTasksAchievement: return stats.totalTasksCompleted >= 10
        case.OneMinAchievement: return stats.totalMinutesFocused >= 1
        case.ThirtyMinAchievement: return stats.totalMinutesFocused >= 30
        case.OneHourAchievement: return stats.totalMinutesFocused >= 60
        case.GiveFoodAchievement_3: return pet.totalFoodReceived >= 3
        case.GiveFoodAchievement_30: return pet.totalFoodReceived >= 30
        case.GiveFoodAchievement_300: return pet.totalFoodReceived >= 300
        case.GiveToysAchievement_3: return pet.totalToysReceived >= 3
        case.GiveToysAchievement_30: return pet.totalToysReceived >= 30
        case.GiveToysAchievement_300: return pet.totalToysReceived >= 300
        case.MoodStreakAchievement_3: return pet.maxHighMoodStreak >= 3
        case.MoodStreakAchievement_30: return pet.maxHighMoodStreak >= 30
        case.MoodStreakAchievement_300: return pet.maxHighMoodStreak >= 300
        case.EnergyStreakAchievement_3: return pet.maxHighEnergyStreak >= 3
        case.EnergyStreakAchievement_30: return pet.maxHighEnergyStreak >= 30
        case.EnergyStreakAchievement_300: return pet.maxHighEnergyStreak >= 300
        }
    }
}
