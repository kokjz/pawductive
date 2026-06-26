//
//  UserStatsTests.swift
//  PawductiveTests
//
//  Created by Kok Jun Zhe on 16/6/26.
//

import Foundation
import Testing
import SwiftData
@testable import Pawductive

@Suite struct UserStatsTests {
    //temp db
    @MainActor
    private func makeInMemoryContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: UserStats.self, configurations: config)
        return ModelContext(container)
    }
    
    //test 1: default initialisation
    @Test func testUserStatsInit() {
        let stats = UserStats()
        #expect(stats.totalTasksCompleted == 0)
        #expect(stats.totalMinutesFocused == 0)
        #expect(stats.totalCoinsEarned == 0)
        #expect(stats.currentStreak == 0)
        #expect(stats.lastActiveDate == nil)
    }
    
    //test 2: db persistence
    @Test @MainActor func testSaveAndUpdate() throws {
        let context = try makeInMemoryContext()
        let stats = UserStats()
        context.insert(stats)
        try context.save()
        
        stats.totalTasksCompleted += 1
        stats.totalMinutesFocused += 1
        stats.totalCoinsEarned += 1
        
        let descriptor = FetchDescriptor<UserStats>()
        let fetchedStatsList = try context.fetch(descriptor)
        let fetchedStats = fetchedStatsList.first
        #expect(fetchedStatsList.count == 1)
        #expect(fetchedStats?.totalTasksCompleted == 1)
        #expect(fetchedStats?.totalMinutesFocused == 1)
        #expect(fetchedStats?.totalCoinsEarned == 1)
    }
    
    //test 3: achievement unlock logic
    @Test @MainActor func testAchievementUnlocks() {
        let stats = UserStats()
        #expect(Achievement.OneTaskAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.FiveTasksAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.TenTasksAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.OneMinAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.ThirtyMinAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isUnlocked(stats: stats) == false)
        
        stats.totalTasksCompleted = 1
        #expect(Achievement.OneTaskAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.TenTasksAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.OneMinAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.ThirtyMinAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isUnlocked(stats: stats) == false)
        
        stats.totalTasksCompleted = 5
        #expect(Achievement.OneTaskAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.OneMinAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.ThirtyMinAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isUnlocked(stats: stats) == false)
        
        stats.totalTasksCompleted = 10
        #expect(Achievement.OneTaskAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.OneMinAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.ThirtyMinAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isUnlocked(stats: stats) == false)
        
        stats.totalMinutesFocused = 1
        #expect(Achievement.OneTaskAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.OneMinAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.ThirtyMinAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isUnlocked(stats: stats) == false)
        
        stats.totalMinutesFocused = 30
        #expect(Achievement.OneTaskAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.OneMinAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.ThirtyMinAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.OneHourAchievement.isUnlocked(stats: stats) == false)
        
        stats.totalMinutesFocused = 60
        #expect(Achievement.OneTaskAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.OneMinAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.ThirtyMinAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.OneHourAchievement.isUnlocked(stats: stats) == true)
        
        stats.totalTasksCompleted = 0
        #expect(Achievement.OneTaskAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.FiveTasksAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.TenTasksAchievement.isUnlocked(stats: stats) == false)
        #expect(Achievement.OneMinAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.ThirtyMinAchievement.isUnlocked(stats: stats) == true)
        #expect(Achievement.OneHourAchievement.isUnlocked(stats: stats) == true)
    }
    
    //test 4: user streak logic
    @Test @MainActor func testUserStreak() throws {
        let context = try makeInMemoryContext()
        let viewModel = TimerViewModel()
        viewModel.startTimer(minutes: 1)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        //first completion
        let stats = UserStats()
        context.insert(stats)
        try context.save()
        viewModel.claimRewards(context: context)
        #expect(stats.currentStreak == 1)
        #expect(stats.lastActiveDate != nil)
        
        //streak maintained
        stats.currentStreak = 6
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        stats.lastActiveDate = yesterday
        viewModel.claimRewards(context: context)
        #expect(stats.currentStreak == 7) //SIX SEVENNNNN
        
        //no double-incrementing for two completions in same day
        stats.currentStreak = 7
        stats.lastActiveDate = Date()
        try context.save()
        viewModel.claimRewards(context: context)
        #expect(stats.currentStreak == 7)
        
        //streak broken
        stats.currentStreak = 7
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        stats.lastActiveDate = twoDaysAgo
        viewModel.claimRewards(context: context)
        #expect(stats.currentStreak == 1)
    }
    
    //test 5: streak maintenance on app launch
    @Test @MainActor func testLaunchStreakReset() throws {
        //first launch
        let container1 = DataContainer(loadInventory: false, inMemory: false) //write to disk for test only, clean up later
        let context1 = container1.context
        let descriptor = FetchDescriptor<UserStats>()
        let statsList = try context1.fetch(descriptor)
        guard let stats = statsList.first else { Issue.record("UserStats not seeded on first run"); return }
        
        //simulate broken streak
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        stats.currentStreak = 5
        stats.lastActiveDate = twoDaysAgo
        try context1.save()
        
        //second launch
        let container2 = DataContainer(loadInventory: false, inMemory: false)
        let context2 = container2.context
        let statsList2 = try context2.fetch(descriptor)
        let stats2 = statsList2.first
        #expect(stats2?.currentStreak == 0) //should have detected broken streak and reset
        
        //cleanup
        let userDescriptor = FetchDescriptor<UserProfile>()
        if let users = try? context2.fetch(userDescriptor) {
            for user in users { context2.delete(user) }
        }
        if let stats = try? context2.fetch(descriptor) {
            for stat in stats { context2.delete(stat) }
        }
        try? context2.save()
    }
    
    //test 6: verify streak expiry date
    @Test @MainActor func testStreakExpiryDate() throws {
        let stats = UserStats()
        #expect(stats.streakExpiryDate() == nil)
        
        // Streak is 0
        stats.lastActiveDate = Date()
        #expect(stats.streakExpiryDate() == nil)
        
        // Streak is not 0
        stats.currentStreak = 1
        let lastActveDate = try #require(stats.lastActiveDate)
        let expiryDate = Calendar.current.date(
            byAdding: DateComponents(day: 2),
            to: Calendar.current.startOfDay(for: lastActveDate)
        )
        #expect(stats.streakExpiryDate() == expiryDate)
    }
}
