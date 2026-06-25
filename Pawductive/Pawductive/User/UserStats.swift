//
//  UserStats.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 15/6/26.
//

import Foundation
import SwiftData

@Model
final class UserStats {
    @Attribute(.unique) var id: UUID
    
    //cumulative stats
    var totalTasksCompleted: Int
    var totalMinutesFocused: Int
    var totalCoinsEarned: Int
    
    //streak tracking
    var currentStreak: Int
    var lastActiveDate: Date?
    
    init(
        id: UUID = UUID(),
        totalTasksCompleted: Int = 0,
        totalMinutesFocused: Int = 0,
        totalCoinsEarned: Int = 0,
        currentStreak: Int = 0,
        lastActiveDate: Date? = nil
    ) {
        self.id = UUID()
        self.totalTasksCompleted = totalTasksCompleted
        self.totalMinutesFocused = totalMinutesFocused
        self.totalCoinsEarned = totalCoinsEarned
        self.currentStreak = currentStreak
        self.lastActiveDate = lastActiveDate
    }
    
    func streakExpiryDate() -> Date? {
        guard currentStreak > 0 else { return nil }
        guard let date = self.lastActiveDate else { return nil }
        return Calendar.current.date(
            byAdding: DateComponents(day: 2),
            to: Calendar.current.startOfDay(for: date)
        )
    }
}
