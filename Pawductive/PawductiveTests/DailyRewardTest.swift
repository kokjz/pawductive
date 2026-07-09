//
//  DailyRewardTest.swift
//  PawductiveTests
//
//  Created by Lee Zi Rong on 9/7/26.
//

import Foundation
import Testing
@testable import Pawductive

struct DailyRewardTest {

    @Test @MainActor func testUpdate() async throws {
        let dailyReward = DailyReward()
        
        // Claimed reward today
        // Award bonus coins tomorrow
        dailyReward.bonusCoins = nil
        dailyReward.claimed = true
        var nextDay = Calendar.current.startOfDay(
            for: Calendar.current.date(byAdding: .day, value: 1, to: dailyReward.lastUpdatedOn)!)
        dailyReward.update(date: nextDay)
        #expect(dailyReward.bonusCoins != nil)
        #expect(dailyReward.claimed == false)
        #expect(dailyReward.lastUpdatedOn == nextDay)
        
        // Did not claim reward today
        // No bonus coins tomorrow
        nextDay = Calendar.current.startOfDay(
            for: Calendar.current.date(byAdding: .day, value: 1, to: dailyReward.lastUpdatedOn)!)
        dailyReward.update(date: nextDay)
        #expect(dailyReward.bonusCoins == nil)
        #expect(dailyReward.claimed == false)
        #expect(dailyReward.lastUpdatedOn == nextDay)
    }
    
    @Test @MainActor func testClaimReward() async throws {
        let dailyReward = DailyReward()
        let user = UserProfile(coins: 0)
        
        // Claim food successfully
        dailyReward.reward = "Corn"
        dailyReward.rewardType = "Food"
        dailyReward.bonusCoins = nil
        
        dailyReward.claimed = true
        dailyReward.claimReward(user: user)
        #expect(dailyReward.claimed)
        #expect(user.foodInventory.isEmpty)
        
        dailyReward.claimed = false
        dailyReward.claimReward(user: user)
        #expect(dailyReward.claimed)
        #expect(user.foodInventory[dailyReward.reward] == 1)
        
        // Claim toy successfully
        dailyReward.reward = "Tree Branch"
        dailyReward.rewardType = "Toy"
        dailyReward.bonusCoins = nil
        
        dailyReward.claimed = true
        dailyReward.claimReward(user: user)
        #expect(dailyReward.claimed)
        #expect(user.toyInventory.isEmpty)
        
        dailyReward.claimed = false
        dailyReward.claimReward(user: user)
        #expect(dailyReward.claimed)
        #expect(user.toyInventory[dailyReward.reward] == 1)
        
        // Claim coins successfully
        dailyReward.reward = ""
        dailyReward.rewardType = ""
        dailyReward.bonusCoins = 30
        
        dailyReward.claimed = true
        dailyReward.claimReward(user: user)
        #expect(dailyReward.claimed)
        #expect(user.coins == 0)
        
        dailyReward.claimed = false
        dailyReward.claimReward(user: user)
        #expect(dailyReward.claimed)
        #expect(user.coins == 30)
    }
}
