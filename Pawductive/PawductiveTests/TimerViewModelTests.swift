//
//  TimerViewModelTests.swift
//  PawductiveTests
//
//  Created by Kok Jun Zhe on 28/5/26.
//

import Testing
import SwiftData
@testable import Pawductive

@Suite struct TimerViewModelTests {
    //create temp database for testing
    @MainActor
    private func makeInMemoryContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DataContainer.appSchema, configurations: [config])
        return ModelContext(container)
    }

    //test 1: timer starts with clean, empty values
    @Test func testInitialState() {
        let viewModel = TimerViewModel()
        
        #expect(viewModel.timeRemaining == 0)
        #expect(viewModel.isRunning == false)
        #expect(viewModel.isCompleted == false)
        #expect(viewModel.isPaused == false)
    }

    //test 2: correct seconds calculation on timer start
    @Test func testStartTimer() {
        let viewModel = TimerViewModel()
        
        viewModel.startTimer(minutes: 25)
        
        #expect(viewModel.timeRemaining == 25 * 60)
        #expect(viewModel.isRunning == true)
        #expect(viewModel.isCompleted == false)
        #expect(viewModel.isPaused == false)
    }

    //test 3: failed session resets state
    @Test func testFailSession() {
        let viewModel = TimerViewModel()
        
        viewModel.startTimer(minutes: 25)
        viewModel.failSession()
        
        #expect(viewModel.isRunning == false)
        #expect(viewModel.timeRemaining == 0)
        #expect(viewModel.isPaused == false)
    }

    //test 4: rewards write accurately to database
    @Test @MainActor func testClaimRewardsCreatesProfileAndAddsCoins() throws {
        let context = try makeInMemoryContext()
        let viewModel = TimerViewModel()
        
        viewModel.startTimer(minutes: 1)
        viewModel.claimRewards(context: context)
        
        let descriptor = FetchDescriptor<UserProfile>()
        let profiles = try context.fetch(descriptor)
        
        #expect(profiles.count == 1)
        #expect(profiles.first?.coins == 101)
    }
    
    //test 5: disallow simultaneously running timers
    @Test func testStartingNewTimerWhileAlreadyRunningOverwritesSuccessfully() {
        let viewModel = TimerViewModel()
        
        viewModel.startTimer(minutes: 25)
        #expect(viewModel.timeRemaining == 25 * 60)
        
        viewModel.startTimer(minutes: 10)
        
        #expect(viewModel.timeRemaining == 10 * 60)
        #expect(viewModel.isRunning == true)
    }
    
    //test 6: dynamic currency gain formula
    @Test func testDynamicCurrGainFormula() {
        let viewModel = TimerViewModel()
        
        //10min
        viewModel.startTimer(minutes: 10)
        let m1 = Double(viewModel.totalDuration / 60)
        let coins1 = Int(m1 + (m1 * m1 / 100))
        #expect(coins1 == 11)
        
        //30min
        viewModel.startTimer(minutes: 30)
        let m2 = Double(viewModel.totalDuration / 60)
        let coins2 = Int(m2 + (m2 * m2 / 100))
        #expect(coins2 == 39)
        
        //60min
        viewModel.startTimer(minutes: 60)
        let m3 = Double(viewModel.totalDuration / 60)
        let coins3 = Int(m3 + (m3 * m3 / 100))
        #expect(coins3 == 96)
    }
    
    //test 7: pause and resume
    @Test func testPauseAndResume() {
        let viewModel = TimerViewModel()
        
        viewModel.startTimer(minutes: 25)
        #expect(viewModel.isRunning == true)
        #expect(viewModel.isPaused == false)
        
        viewModel.pauseTimer()
        #expect(viewModel.isPaused == true)
        #expect(viewModel.isRunning == true)
        
        viewModel.resumeTimer()
        #expect(viewModel.isPaused == false)
        #expect(viewModel.isRunning == true)
        
        viewModel.pauseTimer()
        #expect(viewModel.isPaused == true)
        viewModel.failSession()
        #expect(viewModel.isPaused == false)
        #expect(viewModel.isRunning == false)
    }
    
    //test 8: streak-based coin multiplier
    @Test @MainActor func testStreakBasedCoinMultiplier() throws {
        let context = try makeInMemoryContext()
        let viewModel = TimerViewModel()
        
        //10 day streak
        let stats = UserStats()
        stats.currentStreak = 10
        context.insert(stats)
        try context.save()
        viewModel.startTimer(minutes: 60)
        viewModel.claimRewards(context: context)
        let profileDescriptor = FetchDescriptor<UserProfile>()
        let profiles = try context.fetch(profileDescriptor)
        #expect(profiles.count == 1)
        #expect(profiles.first?.coins == 215)
        #expect(stats.totalCoinsEarned == 115)
        if let firstProfile = profiles.first {
            context.delete(firstProfile)
            try context.save()
        }
        
        //30 day streak (should be capped at 50%)
        stats.currentStreak = 30
        try context.save()
        viewModel.startTimer(minutes: 60)
        viewModel.claimRewards(context: context)
        let updatedProfiles = try context.fetch(profileDescriptor)
        #expect(updatedProfiles.first?.coins == 244)
        #expect(stats.totalCoinsEarned == 115 + 144)
    }
}
