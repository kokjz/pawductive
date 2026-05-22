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
    
    private var timer: Timer?
    
    //initiate timer
    func startTimer(minutes: Int) {
        self.totalDuration = minutes * 60
        self.timeRemaining = self.totalDuration
        self.isRunning = true
        self.isCompleted = false
        
        timer?.invalidate() //stop old timers
        
        //schedule tick timer on main thread
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
    }
    
    //end session success: rewards
    func claimRewards(context: ModelContext) {
        calculateReward(context: context)
    }
    
    //end session fail
    func failSession() {
        timer?.invalidate()
        self.isRunning = false
        self.timeRemaining = 0
        print("Session failed")
    }
    
    //coin calculation
    private func calculateReward(context: ModelContext) {
        //placeholder formula, 1 coin per min
        let coinsEarned = totalDuration / 60
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
        
        try? context.save()
    }
    
    //prevent memory leaks
    deinit {
        timer?.invalidate()
    }
}
