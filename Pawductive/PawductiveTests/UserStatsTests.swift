//
//  UserStatsTests.swift
//  PawductiveTests
//
//  Created by Kok Jun Zhe on 16/6/26.
//

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
        #expect(Achievement.OneTaskAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.FiveTasksAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.TenTasksAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.OneMinAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.ThirtyMinAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isunlocked(stats: stats) == false)
        
        stats.totalTasksCompleted = 1
        #expect(Achievement.OneTaskAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.TenTasksAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.OneMinAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.ThirtyMinAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isunlocked(stats: stats) == false)
        
        stats.totalTasksCompleted = 5
        #expect(Achievement.OneTaskAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.OneMinAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.ThirtyMinAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isunlocked(stats: stats) == false)
        
        stats.totalTasksCompleted = 10
        #expect(Achievement.OneTaskAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.OneMinAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.ThirtyMinAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isunlocked(stats: stats) == false)
        
        stats.totalMinutesFocused = 1
        #expect(Achievement.OneTaskAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.OneMinAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.ThirtyMinAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.OneHourAchievement.isunlocked(stats: stats) == false)
        
        stats.totalMinutesFocused = 30
        #expect(Achievement.OneTaskAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.OneMinAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.ThirtyMinAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.OneHourAchievement.isunlocked(stats: stats) == false)
        
        stats.totalMinutesFocused = 60
        #expect(Achievement.OneTaskAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.FiveTasksAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.TenTasksAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.OneMinAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.ThirtyMinAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.OneHourAchievement.isunlocked(stats: stats) == true)
        
        stats.totalTasksCompleted = 0
        #expect(Achievement.OneTaskAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.FiveTasksAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.TenTasksAchievement.isunlocked(stats: stats) == false)
        #expect(Achievement.OneMinAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.ThirtyMinAchievement.isunlocked(stats: stats) == true)
        #expect(Achievement.OneHourAchievement.isunlocked(stats: stats) == true)
    }
}
