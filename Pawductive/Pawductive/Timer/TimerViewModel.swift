//
//  TimerViewModel.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

import Foundation
import Observation
import SwiftData

@Observable
class TimerViewModel {
    var timeRemaining: Int = 0
    var totalDuration: Int = 0
    var isRunning: Bool = false
    var isCompleted: Bool = false
    var isPaused: Bool = false
    private var timer: Timer?
    
    //initiate timer
    func startTimer(minutes: Int) {
        self.totalDuration = minutes * 60
        self.timeRemaining = self.totalDuration
        self.isRunning = true
        self.isCompleted = false
        self.isPaused = false
        timer?.invalidate() //stop old timers
        
        //schedule tick timer on main thread
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in self?.tick() }
    }
    
    func pauseTimer() {
        guard isRunning && !isPaused else { return }
        timer?.invalidate()
        self.isPaused = true
    }
    
    func resumeTimer() {
        guard isRunning && isPaused else { return }
        self.isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in self?.tick() }
    }
    
    //per-second tick
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            finishCountdown()
        }
    }
    
    //end session success: stop clock
    private func finishCountdown() {
        timer?.invalidate()
        self.isRunning = false
        self.isCompleted = true
        self.isPaused = false
    }
    
    //end session success: rewards
    func claimRewards(context: ModelContext) {
        calculateReward(context: context)
    }
    
    //end session fail
    func failSession() {
        timer?.invalidate()
        self.isRunning = false
        self.isPaused = false
        self.timeRemaining = 0
        print("Session failed")
    }
    
    //coin calculation
    private func calculateReward(context: ModelContext) {
        //new formula, ramps up coin gain rate per extra min spent
        let minsFocused = Double(totalDuration / 60)
        let coinsEarned = Int(minsFocused + (minsFocused * minsFocused / 100.0))
        print("Earned \(coinsEarned) coins")
        
        //fetch user profile
        let descriptor = FetchDescriptor<UserProfile>()
        if let profiles = try? context.fetch(descriptor), let profile = profiles.first {
            //if profile exist add coins
            profile.coins += coinsEarned
            print("New balance: \(profile.coins) coins")
        } else {
            //if profile not exist create one and save
            let newProfile = UserProfile(coins: 100 + coinsEarned) //may need to update if UserProfile init changes
            context.insert(newProfile)
            print("Created new profile. Balance: \(newProfile.coins) coins")
        }
        
        //update user stats
        let statsDescriptor = FetchDescriptor<UserStats>()
        if let statsList = try? context.fetch(statsDescriptor), let stats = statsList.first {
            stats.totalTasksCompleted += 1
            let minutesFocused = totalDuration / 60
            stats.totalMinutesFocused += minutesFocused
            stats.totalCoinsEarned += coinsEarned
            updateStreak(for: stats)
            print("User stats updated success. Tasks: \(stats.totalTasksCompleted), Mins: \(stats.totalMinutesFocused), Coins: \(stats.totalCoinsEarned)")
        }
        
        //update daily missions
        if let missionManager = try? context.fetch(FetchDescriptor<MissionManager>()).first {
            missionManager.updateActiveMissions(
                missions: DataContainer.dailyMissions,
                details: MissionDetails(action: "DO", targetType: "TASK", targetName: "Number"),
                progress: 1
            )
            
            missionManager.updateActiveMissions(
                missions: DataContainer.dailyMissions,
                details: MissionDetails(action: "DO", targetType: "TASK", targetName: "Duration"),
                progress: Int(minsFocused)
            )
        }
            
        try? context.save()
    }
    
    //update streak
    private func updateStreak(for stats: UserStats) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let lastActive = stats.lastActiveDate {
            let lastActiveStartOfDay = calendar.startOfDay(for: lastActive)
            let components = calendar.dateComponents([.day], from: lastActiveStartOfDay, to: today)
            if let daysBetween = components.day {
                if daysBetween == 1 {
                    stats.currentStreak += 1
                } else if daysBetween > 1 {
                    stats.currentStreak = 1
                }
            }
        } else {
            stats.currentStreak = 1
        }
        stats.lastActiveDate = Date()
    }
   
    //prevent memory leaks
    deinit {
        timer?.invalidate()
    }
}
