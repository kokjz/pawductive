//
//  DailyReward.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 9/7/26.
//

import Foundation
import SwiftData

@Model
class DailyReward {
    var reward: String
    var rewardType: String
    var bonusCoins: Int?
    var claimed: Bool
    var lastUpdatedOn: Date
    
    init() {
        let rewardDetails = DailyReward.pickRandomReward()
        self.reward = rewardDetails.first!
        self.rewardType = rewardDetails.last!
        self.bonusCoins = nil
        self.claimed = false
        self.lastUpdatedOn = Date()
    }
    
    private static func pickRandomReward() -> [String] {
        let randomInt = Int.random(in: 1...2)
        if randomInt == 1 {
            return [Food.allFoods.randomElement()!.name, "Food"]
        } else {
            return [Toy.allToys.randomElement()!.name, "Toy"]
        }
    }
    
    private static func pickRandomBonusCoins() -> Int {
        return Int.random(in: 3...9) * 10
    }
    
    func update(date: Date = Date()) {
        guard date > lastUpdatedOn else { return }
        if Calendar.current.isDate(date, inSameDayAs: lastUpdatedOn) {
            lastUpdatedOn = date
            return
        }
        
        let rewardDetails = DailyReward.pickRandomReward()
        reward = rewardDetails.first!
        rewardType = rewardDetails.last!
        
        bonusCoins = nil
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: lastUpdatedOn) else { return }
        if claimed && Calendar.current.isDate(date, inSameDayAs: nextDay) {
            bonusCoins = DailyReward.pickRandomBonusCoins()
        }
        
        claimed = false
        lastUpdatedOn = date
    }
    
    func claimReward(date: Date = Date(), user: UserProfile) {
        update(date: date)
        guard !claimed else { return }
        if rewardType == "Food" {
            user.foodInventory[reward, default: 0] += 1
        } else if rewardType == "Toy" {
            user.toyInventory[reward, default: 0] += 1
        }
        user.coins += bonusCoins ?? 0
        claimed = true
    }
}
