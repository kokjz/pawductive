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
        let container = try ModelContainer(for: UserProfile.self, configurations: config)
        return ModelContext(container)
    }

    //test 1: timer starts with clean, empty values
    @Test func testInitialState() {
        let viewModel = TimerViewModel()
        
        #expect(viewModel.timeRemaining == 0)
        #expect(viewModel.isRunning == false)
        #expect(viewModel.isCompleted == false)
    }

    //test 2: correct seconds calculation on timer start
    @Test func testStartTimer() {
        let viewModel = TimerViewModel()
        
        viewModel.startTimer(minutes: 25)
        
        #expect(viewModel.timeRemaining == 25 * 60)
        #expect(viewModel.isRunning == true)
        #expect(viewModel.isCompleted == false)
    }

    //test 3: failed session resets state
    @Test func testFailSession() {
        let viewModel = TimerViewModel()
        
        viewModel.startTimer(minutes: 25)
        viewModel.failSession()
        
        #expect(viewModel.isRunning == false)
        #expect(viewModel.timeRemaining == 0)
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
}
